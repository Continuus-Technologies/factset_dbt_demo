## Pre-requisites & Setup

- Snowflake account available with account admin role
- Create a user, role, and warehouse for use with DBT
  - Add user to the role
  - Grant the role "Operate" and "Usage" privileges on the warehouse
- Get the free FactSet data from the Snowflake Marketplace
  - Install to the default database in Snowflake
  - Grant the DBT role imported privileges to the FactSet shared databases
    - FactSet Analytics (sample)
    - FactSet Data Management Solutions (sample)
    - FactSet Supply Chain Relationships (sample)
- Create a new database called "factset_demo" within Snowflake
  - Grant the DBT role the following privileges on the "factset_demo" database
    - Create Schema
    - Ownership - Future Schema
    - Ownership - Future Table
    - Ownership - Future View
    - Usage
- Install DBT (https://docs.getdbt.com/docs/core/installation)
  - Approach varies based on local/remote environments
- Configure DBT to use Snowflake credentials
  - Locally, via DBT profiles
  - Remotely, via Git CI/CD
- Enable Anaconda python packages within Snowflake (https://docs.snowflake.com/en/developer-guide/udf/python/udf-python-packages.html#using-third-party-packages-from-anaconda)
  - Required to run Python DBT models
  - If not possible (requires ORGADMIN role in Snowflake), then disable Python model within Marts folder and model yml

```yaml
factset_demo:
  target: demo
  outputs:
    demo:
      type: snowflake
      account: "{{ env_var('SNOWFLAKE_ACCOUNT') }}"

      user: FACTSET_DEMO_DBT_USER
      password: "{{ env_var('SNOWFLAKE_PASSWORD') }}"
      
      role: FACTSET_DEMO_ROLE
      database: FACTSET_DEMO
      warehouse: FACTSET_DEMO_WH
      schema: DEMO
      threads: 4
```

## Demo Outline

- Snowflake Marketplace source data (FactSet sample data)
  - FactSet Analytics (sample)
  - FactSet Data Management Solutions (sample)
  - FactSet Supply Chain Relationships (sample)
- DBT project structure and configurations (dbt_project.yml)
  - Staging, Intermediate, Marts
- Commonly used commands
  - dbt deps (install/upgrades package dependencies)
  - dbt build (compile, run, test)
- Packages overview (packages.yml)
  - Versioning and installation (dbt deps)
- Staging models to rename/tranform source data
  - Registering source tables via yml
- Intermediate models to aggregate internal models
- Marts model for consumable data
- Python example model
  - Python and SQL model interoperability
- Tests overview (both through yml and sql)
- Model contracts and enforcement
  - Data types and enforcement settings
- Source freshness tests

```shell
dbt source freshness
```

- Generation of documentation / lineage tracking

```shell
dbt docs generate
```

## Interactive Demo

- Validating data assumptions
  - Uncomment table test with Marts model
  - Build project to see error message
  - Run provided SQL to determine the problem (hint, look at the unique key details)
  - Correct test based on findings
- Enforcing model contracts
  - Uncomment line within _supplier\_customers_ model to change array to text
  - Build project to see error message
  - Recomment line to fix
