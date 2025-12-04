"""
Standardize and clean business locations into sectors/subsectors.

Input:
    data/ca_businesses_with_ai_franchise.json  (list of dicts)

Output:
    data/nodes/ca_businesses_with_ai_franchise_sectors.json
        Fields:
            id, business_name, url, address, city, zip_code,
            latitude, longitude, blockgroup, avg_rating, geom,
            franchise_type, is_franchise, has_valid_coordinates,
            category_original, category_sector, category_subsector
"""

import json
import re
from pathlib import Path
from typing import Dict, List, Optional, Tuple

INPUT_PATH = Path("data") / "ca_businesses_with_ai_franchise.json"
OUTPUT_PATH = Path("data") / "nodes" / "ca_businesses_with_ai_franchise_sectors.json"

# NAICS-like taxonomy (sector -> subsector -> keywords)
CANONICAL_TAXONOMY: Dict[str, Dict[str, List[str]]] = {
    "Food & Beverage": {
        "Restaurants": ["restaurant", "diner", "bistro", "grill", "eatery"],
        "Fast Food": ["fast food", "burger", "pizza", "taco", "sandwich"],
        "Coffee & Tea": ["coffee", "tea", "espresso", "cafe"],
        "Bars & Nightlife": ["bar", "pub", "lounge", "nightclub", "brewery", "tavern"],
        "Bakery & Desserts": ["bakery", "pastry", "dessert", "ice cream", "donut", "cake"],
        "Specialty Food": ["deli", "grocery", "market", "butcher", "seafood", "organic"],
    },
    "Retail": {
        "Clothing & Apparel": ["clothing", "apparel", "fashion", "boutique", "shoes", "accessories"],
        "General Merchandise": ["department store", "variety store", "discount", "warehouse"],
        "Specialty Retail": ["gift", "toys", "books", "music", "electronics", "hobby"],
        "Home & Garden": ["furniture", "home decor", "garden", "hardware", "appliances"],
        "Automotive Retail": ["auto parts", "tire", "accessories", "motorcycle"],
    },
    "Personal Services": {
        "Health & Beauty": ["salon", "spa", "barber", "nail", "beauty", "massage", "cosmetic"],
        "Fitness & Recreation": ["gym", "fitness", "yoga", "pilates", "martial arts", "dance"],
        "Dry Cleaning & Laundry": ["dry clean", "laundry", "alterations"],
        "Pet Services": ["pet grooming", "veterinary", "vet", "animal"],
    },
    "Professional Services": {
        "Financial Services": ["bank", "credit union", "insurance", "financial", "investment", "tax"],
        "Real Estate": ["real estate", "property management", "realty"],
        "Legal Services": ["attorney", "lawyer", "legal", "law office"],
        "Accounting": ["accounting", "cpa", "bookkeeping"],
        "Consulting": ["consulting", "consultant", "advisory"],
    },
    "Healthcare": {
        "Medical Offices": ["doctor", "physician", "clinic", "medical", "dentist", "dental"],
        "Pharmacy": ["pharmacy", "drugstore", "prescription"],
        "Specialized Healthcare": ["chiropractor", "optometry", "physical therapy", "acupuncture"],
        "Mental Health": ["counseling", "therapy", "psychologist", "psychiatrist"],
    },
    "Automotive Services": {
        "Repair & Maintenance": ["auto repair", "mechanic", "oil change", "brake", "muffler"],
        "Car Wash & Detailing": ["car wash", "detailing", "auto spa"],
        "Towing & Roadside": ["towing", "roadside", "wrecker"],
    },
    "Home Services": {
        "Construction & Contractors": ["construction", "contractor", "builder", "remodeling"],
        "Plumbing & HVAC": ["plumbing", "plumber", "hvac", "heating", "cooling", "air conditioning"],
        "Electrical": ["electrical", "electrician"],
        "Cleaning Services": ["cleaning", "janitorial", "maid", "housekeeping"],
        "Landscaping": ["landscaping", "lawn care", "tree service", "gardening"],
    },
    "Education & Childcare": {
        "Schools": ["school", "academy", "learning center", "education"],
        "Tutoring": ["tutoring", "tutor", "test prep"],
        "Childcare": ["daycare", "preschool", "child care", "nursery"],
    },
    "Entertainment & Recreation": {
        "Arts & Entertainment": ["theater", "cinema", "movie", "entertainment", "museum"],
        "Sports & Recreation": ["sports", "recreation", "bowling", "golf", "skating"],
        "Events & Venues": ["event", "venue", "banquet", "catering"],
    },
    "Lodging": {
        "Hotels & Motels": ["hotel", "motel", "inn", "lodge"],
        "Alternative Lodging": ["bed and breakfast", "hostel", "vacation rental"],
    },
    "Technology": {
        "IT Services": ["computer repair", "it services", "tech support", "software"],
        "Telecommunications": ["wireless", "phone", "mobile", "telecom"],
    },
    "Other Services": {
        "Business Services": ["printing", "shipping", "mailing", "packaging", "copy"],
        "Travel Services": ["travel agency", "travel", "tour"],
        "Miscellaneous": [],  # default bucket
    },
}


def _build_category_map():
    mapping: Dict[str, Tuple[str, str]] = {}
    for sector, subsectors in CANONICAL_TAXONOMY.items():
        for subsector, keywords in subsectors.items():
            for kw in keywords:
                mapping[kw.lower()] = (sector, subsector)
    return mapping


CATEGORY_MAP = _build_category_map()


def normalize_category(cat: str) -> str:
    if not cat:
        return ""
    normalized = cat.lower().strip()
    normalized = re.sub(r"\\s*(services?|store|shop|center|company|inc\\.?|llc|corp\\.?)\\s*$", "", normalized)
    normalized = re.sub(r"\\s+", " ", normalized)
    return normalized


def classify_category(cat: str) -> Tuple[str, str]:
    norm = normalize_category(cat)
    if not norm:
        return ("Other Services", "Miscellaneous")
    for kw, (sec, sub) in CATEGORY_MAP.items():
        if kw in norm:
            return (sec, sub)
    return ("Other Services", "Miscellaneous")


def franchise_fields(raw: str) -> Tuple[str, Optional[bool]]:
    val = (raw or "").strip().upper()
    if val in {"FRANCHISE", "CHAIN"}:
        return "FRANCHISE", True
    if val in {"INDEPENDENT", "LOCAL"}:
        return "INDEPENDENT", False
    return "UNKNOWN", None


def coord_ok(lat: Optional[float], lon: Optional[float]) -> Optional[bool]:
    try:
        if lat is None or lon is None:
            return None
        return 32.5 <= lat <= 42.0 and -124.5 <= lon <= -114.0
    except Exception:
        return None


def clean_record(rec: dict) -> dict:
    category_original = None
    if isinstance(rec.get("categories"), list) and rec["categories"]:
        category_original = str(rec["categories"][0]).strip()
    elif rec.get("category"):
        category_original = str(rec["category"]).strip()
    else:
        category_original = "Unknown"

    sector, subsector = classify_category(category_original)

    lat = None
    lon = None
    try:
        lat = float(rec.get("latitude"))
        lon = float(rec.get("longitude"))
    except Exception:
        pass

    ft, is_fran = franchise_fields(rec.get("franchise"))

    cleaned = {
        "id": rec.get("id"),
        "business_name": rec.get("name"),
        "url": rec.get("url"),
        "address": rec.get("address"),
        "city": rec.get("city"),
        "zip_code": str(rec.get("zip")) if rec.get("zip") is not None else None,
        "latitude": lat,
        "longitude": lon,
        "blockgroup": str(rec.get("blockgroup")) if rec.get("blockgroup") is not None else None,
        "avg_rating": float(rec["avg_rating"]) if rec.get("avg_rating") not in (None, "") else None,
        "geom": rec.get("geom"),
        "franchise_type": ft,
        "is_franchise": is_fran,
        "has_valid_coordinates": coord_ok(lat, lon),
        "category_original": category_original,
        "category_sector": sector,
        "category_subsector": subsector,
    }
    return cleaned


def main():
    src = INPUT_PATH
    dest = OUTPUT_PATH
    dest.parent.mkdir(parents=True, exist_ok=True)

    data = json.loads(src.read_bytes().decode("utf-8"))
    cleaned = [clean_record(rec) for rec in data]

    dest.write_text(json.dumps(cleaned, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"Wrote {len(cleaned)} records to {dest}")


if __name__ == "__main__":
    main()
