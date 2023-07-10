# Config SnowFlake
## In snowflake run the script **create_entities_snowflakes.sql** to create the user, role, database and datawhrehouse.

# Airbytes

## To create the source and destination resources. In the source part will be the csv found in this link: [datasets](https://health.google.com/covid-19/open-data/raw-data). And in the destination should be the connection to the snowflake.

## After creating the resources in Airbyte. You must take the ids of each resource and put their values in the **variables.json** file located at the root of the project.
