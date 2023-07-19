import pandas as pd
from snowflake.snowpark.functions import sum as sum_, array_agg as array_agg_, array_size as array_size_, array_distinct as array_distinct_

def model(dbt, session):

    suppliers = dbt.ref("factset_customer_supplier_relationships")
    supplier_relationships = dbt.ref(
        "stg_factset_supply_chain_relationships__scr_relationships"
    )

    combined = suppliers.join(
        supplier_relationships, 
        on=["customer_factset_entity_id", "supplier_factset_entity_id"], 
        how="left").select(
            suppliers["customer_name"].as_("customer_name"),
            suppliers["customer_factset_entity_id"].as_("customer_factset_entity_id"),
            suppliers["supplier_name"].as_("supplier_name"),
            suppliers["supplier_factset_entity_id"].as_("supplier_factset_entity_id"),
            suppliers["relationship_type"].as_("relationship_type"),
            suppliers["occurrences"].as_("occurrences"),
            supplier_relationships["relationship_keyword1"].as_("relationship_keyword1")
        ).distinct()
    
    rollup = combined.group_by([
        "customer_name",
        "customer_factset_entity_id",
        "relationship_type"]).agg(
            array_distinct_(array_agg_("relationship_keyword1")).as_("keywords"),
            sum_("occurrences").as_("occurrences"),
            array_distinct_(array_agg_("supplier_name")).as_("supplier_list"),
            array_size_(array_distinct_(array_agg_("supplier_name"))).as_("supplier_count"),
        )

    final_df = rollup

    return final_df
