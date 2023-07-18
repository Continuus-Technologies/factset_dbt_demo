WITH
suppliers AS (
    SELECT *
    FROM {{ ref('factset_customer_supplier_relationships') }}
),

supplier_relationships AS (
    SELECT *
    FROM {{ ref('stg_factset_supply_chain_relationships__scr_relationships') }}
),

combined AS (
    SELECT
        ds.customer_name,
        ds.customer_factset_entity_id,
        ds.supplier_name,
        ds.supplier_factset_entity_id,
        ds.relationship_type,
        ds.occurrences,
        sr.relationship_keyword1
    FROM
        suppliers AS ds
    LEFT JOIN supplier_relationships AS sr
        ON
            ds.customer_factset_entity_id = sr.customer_factset_entity_id
            AND ds.supplier_factset_entity_id = sr.supplier_factset_entity_id
),

rollup AS (
    SELECT
        supplier_name,
        supplier_factset_entity_id,
        relationship_type,
        array_agg(DISTINCT relationship_keyword1) AS keywords,
        -- Run this line to break the model contract (array changes to string)
        -- array_to_string(array_agg(DISTINCT relationship_keyword1), ',') AS keywords,
        sum(occurrences) AS occurrences,
        array_agg(DISTINCT customer_name) AS customer_list,
        array_size(array_agg(DISTINCT customer_name)) AS customer_count
    FROM combined
    GROUP BY 1, 2, 3
)

SELECT * FROM rollup
