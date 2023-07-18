WITH
source AS (
    SELECT *
    FROM
        {{ ref('stg_factset_data_management_solutions__dms_entity_structure') }}
),

rollup AS (
    SELECT
        factset_entity_id,
        entity_name,
        depth,
        SYS_CONNECT_BY_PATH(entity_name, ' -> ') AS tree
    FROM source
    START WITH depth = 1
    CONNECT BY
    factset_parent_entity_id = PRIOR factset_entity_id
    ORDER BY tree
)

SELECT * FROM rollup
