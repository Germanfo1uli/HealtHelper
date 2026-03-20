from __future__ import annotations

import re
import sys
from pathlib import Path
from typing import Iterable

try:
    from PIL import Image
except Exception:
    print('Missing dependency: Pillow. Install with: pip install pillow', file=sys.stderr)
    raise

try:
    from pyzbar.pyzbar import decode as barcode_decode
except Exception:
    print('Missing dependency: pyzbar. Install with: pip install pyzbar', file=sys.stderr)
    raise

try:
    import requests
except Exception:
    requests = None

SCAN_DIR = Path(__file__).resolve().parent / 'scan'


def iter_images(folder: Path) -> Iterable[Path]:
    exts = {'.png', '.jpg', '.jpeg', '.bmp', '.tiff', '.tif', '.webp'}
    for path in sorted(folder.iterdir()):
        if path.is_file() and path.suffix.lower() in exts:
            yield path


def decode_barcodes_from_image(path: Path) -> list[str]:
    img = Image.open(path)
    decoded = barcode_decode(img)
    values: list[str] = []
    for item in decoded:
        try:
            values.append(item.data.decode('utf-8'))
        except Exception:
            values.append(item.data.decode('utf-8', errors='replace'))
    return values


def looks_like_gtin(value: str) -> bool:
    return bool(re.fullmatch(r'\d{8}|\d{12}|\d{13}|\d{14}', value.strip()))


def fetch_openfoodfacts(gtin: str) -> dict | None:
    if requests is None:
        return None
    url = f'https://world.openfoodfacts.org/api/v2/product/{gtin}.json'
    try:
        resp = requests.get(url, timeout=10)
        if resp.status_code != 200:
            return None
        data = resp.json()
        if data.get('status') != 1:
            return None
        return data.get('product')
    except Exception:
        return None


def pick_first(*values: object) -> str | None:
    for v in values:
        if isinstance(v, str) and v.strip():
            return v.strip()
    return None


def clean_tag(tag: str) -> str:
    return re.sub(r'^[a-z]{2}:', '', tag).replace('-', ' ')


def join_tags(tags: object) -> str | None:
    if isinstance(tags, list) and tags:
        cleaned = [clean_tag(str(t)) for t in tags if str(t).strip()]
        return ', '.join(cleaned) if cleaned else None
    if isinstance(tags, str) and tags.strip():
        return tags.strip()
    return None


def format_value(value: object, suffix: str | None = None) -> str | None:
    if value is None:
        return None
    try:
        num = float(value)
        if num.is_integer():
            text = str(int(num))
        else:
            text = f'{num:.2f}'.rstrip('0').rstrip('.')
    except Exception:
        text = str(value)
    return f'{text}{suffix}' if suffix else text


def get_nutriment(nutriments: dict, key: str) -> str | None:
    value = nutriments.get(key)
    return format_value(value, None)


def nova_text(nova: object) -> str | None:
    mapping = {
        1: 'NOVA 1 — необработанные/минимально обработанные продукты',
        2: 'NOVA 2 — обработанные кулинарные ингредиенты',
        3: 'NOVA 3 — обработанные продукты',
        4: 'NOVA 4 — ультра‑переработанные продукты',
    }
    try:
        num = int(nova)
        return mapping.get(num)
    except Exception:
        return None


def score_text(label: str | None, kind: str) -> str | None:
    if not label:
        return None
    label = label.upper()
    if kind == 'nutri':
        return f'Nutri‑Score: {label} (A лучше, E хуже)'
    if kind == 'eco':
        return f'Eco‑Score: {label} (A лучше, E хуже)'
    return None


ADDITIVE_INFO = {
    'e100': ('Куркумин (краситель)', 'безопасная'),
    'e200': ('Сорбиновая кислота (консервант)', 'безопасная'),
    'e202': ('Сорбат калия (консервант)', 'безопасная'),
    'e210': ('Бензойная кислота (консервант)', 'спорная'),
    'e211': ('Бензоат натрия (консервант)', 'спорная'),
    'e250': ('Нитрит натрия (консервант)', 'вредная'),
    'e251': ('Нитрат натрия (консервант)', 'спорная'),
    'e300': ('Аскорбиновая кислота (антиоксидант)', 'безопасная'),
    'e330': ('Лимонная кислота (регулятор кислотности)', 'безопасная'),
    'e407': ('Каррагинан (загуститель)', 'спорная'),
    'e412': ('Гуаровая камедь (загуститель)', 'спорная'),
    'e415': ('Ксантановая камедь (загуститель)', 'спорная'),
    'e420': ('Сорбит (подсластитель)', 'спорная'),
    'e621': ('Глутамат натрия (усилитель вкуса)', 'спорная'),
}


def format_additives(tags: object) -> list[str]:
    result: list[str] = []
    if not isinstance(tags, list):
        return result
    for tag in tags:
        t = clean_tag(str(tag)).replace(' ', '')
        if not t:
            continue
        key = t.lower()
        if not key.startswith('e'):
            continue
        info = ADDITIVE_INFO.get(key)
        if info:
            name, risk = info
            result.append(f'{key.upper()}: {name} — {risk}')
        else:
            result.append(f'{key.upper()}: нет данных — уровень неизвестно')
    return result


def print_product_report(product: dict) -> None:
    name = pick_first(product.get('product_name'), product.get('product_name_ru'))
    brand = join_tags(product.get('brands'))
    quantity = pick_first(product.get('quantity'))
    category = join_tags(product.get('categories_tags')) or join_tags(product.get('categories'))
    country = join_tags(product.get('countries_tags')) or join_tags(product.get('countries'))

    ingredients = pick_first(product.get('ingredients_text'), product.get('ingredients_text_ru'))

    nutriments = product.get('nutriments') or {}
    energy_kcal = get_nutriment(nutriments, 'energy-kcal_100g')
    proteins = get_nutriment(nutriments, 'proteins_100g')
    fat = get_nutriment(nutriments, 'fat_100g')
    sat_fat = get_nutriment(nutriments, 'saturated-fat_100g')
    carbs = get_nutriment(nutriments, 'carbohydrates_100g')
    sugars = get_nutriment(nutriments, 'sugars_100g')
    fiber = get_nutriment(nutriments, 'fiber_100g')
    salt = get_nutriment(nutriments, 'salt_100g')
    sodium = get_nutriment(nutriments, 'sodium_100g')

    allergens = join_tags(product.get('allergens_tags')) or pick_first(product.get('allergens'))
    traces = join_tags(product.get('traces_tags')) or pick_first(product.get('traces'))

    additives = format_additives(product.get('additives_tags'))

    analysis_tags = product.get('ingredients_analysis_tags') or []
    palm = 'неизвестно'
    if 'en:palm-oil-free' in analysis_tags:
        palm = 'нет'
    elif 'en:contains-palm-oil' in analysis_tags or 'en:palm-oil' in analysis_tags:
        palm = 'да'
    elif 'en:may-contain-palm-oil' in analysis_tags:
        palm = 'возможно'

    vegan = 'неизвестно'
    if 'en:vegan' in analysis_tags:
        vegan = 'да'
    elif 'en:non-vegan' in analysis_tags:
        vegan = 'нет'

    vegetarian = 'неизвестно'
    if 'en:vegetarian' in analysis_tags:
        vegetarian = 'да'
    elif 'en:non-vegetarian' in analysis_tags:
        vegetarian = 'нет'

    nova = nova_text(product.get('nova_group'))

    nutri_score = score_text(product.get('nutriscore_grade'), 'nutri')
    eco_score = score_text(product.get('ecoscore_grade'), 'eco')

    vitamins = join_tags(product.get('vitamins_tags'))
    minerals = join_tags(product.get('minerals_tags'))

    print('НАЗВАНИЕ И ОБЩИЕ СВЕДЕНИЯ')
    print(f'- Название товара: {name or "нет данных"}')
    print(f'- Бренд: {brand or "нет данных"}')
    print(f'- Количество / вес: {quantity or "нет данных"}')
    print(f'- Категория: {category or "нет данных"}')
    print(f'- Страна производства: {country or "нет данных"}')

    print('\nСОСТАВ')
    print(f'- Полный состав (ингредиенты): {ingredients or "нет данных"}')

    print('\n ПИЩЕВАЯ ЦЕННОСТЬ (на 100г/мл)')
    print(f'- Калорийность (ккал): {energy_kcal or "нет данных"}')
    print(f'- Белки (г): {proteins or "нет данных"}')
    print(f'- Жиры (г): {fat or "нет данных"}, из них насыщенные жиры (г): {sat_fat or "нет данных"}')
    print(f'- Углеводы (г): {carbs or "нет данных"}, из них сахара (г): {sugars or "нет данных"}')
    print(f'- Клетчатка (г): {fiber or "нет данных"}')
    salt_line = salt or sodium
    print(f'- Соль / натрий (г): {salt_line or "нет данных"}')

    print('\n АЛЛЕРГЕНЫ')
    print(f'- Содержит: {allergens or "нет данных"}')
    print(f'- Может содержать следы: {traces or "нет данных"}')

    print('\n ВРЕДНЫЕ И НЕЖЕЛАТЕЛЬНЫЕ КОМПОНЕНТЫ')
    if additives:
        for item in additives:
            print(f'- {item}')
    else:
        print('- Нет данных')

    print('\n АНАЛИЗ СОСТАВА')
    print(f'- Наличие пальмового масла: {palm}')
    print(f'- Продукт веганский: {vegan}')
    print(f'- Продукт вегетарианский: {vegetarian}')
    print(f'- Степень обработки продукта (NOVA группа): {nova or "нет данных"}')

    print('\n РЕЙТИНГИ И ОЦЕНКИ')
    print(f'- Nutri-Score (оценка питательности): {nutri_score or "нет данных"}')
    print(f'- Eco-Score (экологичность): {eco_score or "нет данных"}')

    print('\n ВИТАМИНЫ И МИНЕРАЛЫ')
    print(f'- Витамины: {vitamins or "нет данных"}')
    print(f'- Минералы: {minerals or "нет данных"}')


def print_product_info(raw_value: str) -> None:
    print('Статус: штрих‑код распознан.')

    if looks_like_gtin(raw_value):
        product = fetch_openfoodfacts(raw_value)
        if product:
            print('\nИсточник: OpenFoodFacts')
            print('Данные о товаре получены.')
            print()
            print_product_report(product)
        else:
            print('Данные о товаре не найдены (или нет интернета).')
        return

    print('\nФормат штрих‑кода не распознан как GTIN/EAN/UPC. Данных о товаре нет.')


def main() -> int:
    if not SCAN_DIR.exists():
        print(f'Нет папки: {SCAN_DIR}. Создайте её и положите туда изображения.')
        return 1

    images = list(iter_images(SCAN_DIR))
    if not images:
        print(f'В папке {SCAN_DIR} нет изображений.')
        return 0

    for path in images:
        print('=' * 80)
        print('Файл:', path.name)
        try:
            values = decode_barcodes_from_image(path)
        except Exception as exc:
            print('Не удалось обработать изображение:', exc)
            continue

        if not values:
            print('Статус: штрих‑код не найден.')
            continue

        for idx, value in enumerate(values, start=1):
            print('\n--- Код', idx, '---')
            print_product_info(value)

    return 0


if __name__ == '__main__':
    raise SystemExit(main())
