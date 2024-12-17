# Jaffle Gaggle Customer 360 with DBT

`jaffle_gaggle` is a fictional B2B product. This dbt project transforms raw data from an event stream & app database into a customer 360 view ready for [operational analytics](https://blog.getcensus.com/what-is-operational-analytics/). A customer 360 is a fancy way of saying that you have a holistic dataset that lets understand your customers’ behavior. It involves being able to link together all of the different kinds of data you collect about customers via identity resolution; from the final data model, we can track the users in the warehouse and understand how they are using the application.


### What's in this repo?
This repo contains [seeds](https://docs.getdbt.com/docs/building-a-dbt-project/seeds) that includes some (fake) raw data from a fictional app.

The raw data consists of tables: 
- raw_event
- raw_user
- raw_gaggle
- merged_company_domain
- merged_user

### Running this project
To get up and running with this project:
1. Create a virtual environment to install dbt.

2. Run `pip install -r requirements` to setup the dbt environment.

2. Clone this repository.

3. Change into the `dbt_data_eng` directory from the command line:

```bash
$ cd data-eng-dbt/dbt_data_eng/
```

5. Ensure your profile is setup correctly from the command line:
```bash
$ dbt debug
```

6. Load the CSVs with the demo data set. This materializes the CSVs as tables in your target schema.
```bash
$ dbt seed
```

7. Run the models:
```bash
$ dbt run
```

8. Test the output of the models:
```bash
$ dbt test
```

9. Generate documentation for the project:
```bash
$ dbt docs generate
```

10. View the documentation for the project:
```bash
$ dbt docs serve
```

### Common workflow pattern
Seed or test data is placed in the `seeds` folder, this is where dbt looks for data to insert into the warehouse. Alternate data types can be defined in the `properties.yml` file in this directory.
Macros or UDFs can be defined using jinja syntax and are located in the `macros` folder. The definitions for the data models are stored in the `models` folder, the models are also written with jinja/sql syntax which allows dbt to build the queries for the target database dialect. Models for each layer of the warehouse can be group into folders and each folder can have a yaml file defining the data schema and tests for each column in any table/model.

With every `dbt run` the models are rebuilt in the `target` folder, which means the `dbt run`has to run before every test.