WITH
source AS (
    SELECT *
    FROM
        {{ source('factset_supply_chain_relationships', 'SCR_RELATIONSHIPS') }}
),

renamed AS (
    SELECT
        customer_name,
        customer_factset_entity_id,
        supplier_name,
        supplier_factset_entity_id,
        relationship_keyword1
    FROM source
)

SELECT * FROM renamed
