import pandas as pd

def model(dbt, session):

    suppliers = dbt.ref("factset_customer_supplier_relationships")
    supplier_relationships = dbt.ref(
        "stg_factset_supply_chain_relationships__scr_relationships"
    )

    combined = pd.merge(
        suppliers,
        supplier_relationships,
        how="left",
        left_on=["customer_factset_entity_id", "supplier_factset_entity_id"],
        right_on=["customer_factset_entity_id", "supplier_factset_entity_id"],
    )

    final_df = combined

    return final_df
