WITH
source AS (
    SELECT *
    FROM
        {{ source('factset_analytics', 'EQ_SECTOR_ATTRIBUTION') }}
),

renamed AS (
    SELECT
        securityname,
        symbol,
        parentgrouping,
        groupingname,
        bench_total_return,
        to_date(startdate) AS startdate,
        to_date(enddate) AS enddate
    FROM source
)

SELECT * FROM renamed
