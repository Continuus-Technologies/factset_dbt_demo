select * from {{ ref('factset_customer_supplier_relationships') }}
where
    customer_factset_entity_id = supplier_factset_entity_id
    and relationship_type = 'direct'
