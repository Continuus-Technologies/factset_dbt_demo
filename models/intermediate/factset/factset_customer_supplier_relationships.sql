WITH
source AS (
    SELECT *
    FROM
        {{ ref('stg_factset_supply_chain_relationships__scr_tier_2_suppliers') }}
),

direct AS (
    SELECT
        customer_name,
        customer_factset_entity_id,
        tier1_supplier_name AS supplier_name,
        tier1_supplier_factset_entity_id AS supplier_factset_entity_id,
        'direct' AS relationship_type,
        count(*) AS occurrences
    FROM source
    GROUP BY 1, 2, 3, 4
),

indirect AS (
    SELECT
        customer_name,
        customer_factset_entity_id,
        tier2_supplier_name AS supplier_name,
        tier2_supplier_factset_entity_id AS supplier_factset_entity_id,
        'indirect' AS relationship_type,
        count(*) AS occurrences
    FROM source
    GROUP BY 1, 2, 3, 4
),

combined AS (
    SELECT
        customer_name,
        customer_factset_entity_id,
        supplier_name,
        supplier_factset_entity_id,
        relationship_type,
        occurrences
    FROM direct

    UNION ALL

    SELECT
        customer_name,
        customer_factset_entity_id,
        supplier_name,
        supplier_factset_entity_id,
        relationship_type,
        occurrences
    FROM indirect
)

SELECT * FROM combined
