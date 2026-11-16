# Database Testing Report – FreshFirst Team

## Module
Database / Data and Integrity

## Responsible Member
Rutika

## Database
MySQL – freshfirst_team

## Testing Objective
To verify the correctness of the verify_product_temperature stored procedure.

## Test Results

| Test Case | Input | Expected Result | Actual Result | Status |
|---|---|---|---|---|
| Safe temperature | 5.00°C | SAFE | SAFE | PASS |
| Unsafe temperature | 20.00°C | UNSAFE | UNSAFE | PASS |
| Invalid product ID | 999 | Product not found | Product not found | PASS |
| Minimum boundary | 4.00°C | SAFE | SAFE | PASS |
| Maximum boundary | 12.00°C | SAFE | SAFE | PASS |
| Below minimum | 3.99°C | UNSAFE | UNSAFE | PASS |
| Above maximum | 12.01°C | UNSAFE | UNSAFE | PASS |
| Transaction rollback | Temporary records | No permanent records | Empty result confirmed | PASS |

## Conclusion
The stored procedure correctly checks product temperatures against category storage limits, rejects invalid product IDs, and supports transaction rollback.

All eight database test checks passed.
