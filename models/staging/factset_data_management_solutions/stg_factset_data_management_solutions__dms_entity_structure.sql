WITH
source AS (
    SELECT *
    FROM
        {{ source('factset_data_management_solutions', 'DMS_ENTITY_STRUCTURE') }}
),

renamed AS (
    SELECT
        "factset_parent_entity_id" AS factset_parent_entity_id,
        "parent_entity_name" AS parent_entity_name,
        "factset_entity_id" AS factset_entity_id,
        "entity_name" AS entity_name,
        "entity_type" AS entity_type,
        "depth" AS depth
    FROM source
)

SELECT * FROM renamed
