WITH
source AS (
    SELECT *
    FROM
        {{ source('factset_supply_chain_relationships', 'SCR_TIER_2_SUPPLIERS') }}
),

renamed AS (
    SELECT
        target_co_name AS customer_name,
        target_company_entity_id AS customer_factset_entity_id,
        tier1_supplier_name AS tier1_supplier_name,
        tier1_supplier_factset_entity_id AS tier1_supplier_factset_entity_id,
        t2_supplier_name AS tier2_supplier_name,
        tier2_supplier_factset_entity_id AS tier2_supplier_factset_entity_id
    FROM source
)

SELECT * FROM renamed
