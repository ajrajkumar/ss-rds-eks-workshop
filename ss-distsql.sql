ADD RESOURCE ds_0 (URL="jdbc:postgresql://sharding-pg1.czix8sw33ibu.us-east-2.rds.amazonaws.com:5432/%DB1%",USER=postgres,PASSWORD=sSv6bGPL);
ADD RESOURCE ds_1 (URL="jdbc:postgresql://:5432/$DB2%",USER=postgres,PASSWORD=sSv6bGPL);

CREATE SHARDING ALGORITHM 
database_inline (
	    TYPE(NAME="inline", PROPERTIES("algorithm-expression"="ds_${user_id % 2}"))), 
employee_inline (
	    TYPE(NAME="inline", PROPERTIES("algorithm-expression"="employee_${emp_id % 2}"))); 

CREATE DEFAULT SHARDING DATABASE STRATEGY (
	    TYPE="standard", SHARDING_COLUMN=emp_id, SHARDING_ALGORITHM=database_inline);

CREATE SHARDING KEY GENERATOR snowflake_key_generator (
	    TYPE(NAME="SNOWFLAKE", PROPERTIES("worker-id"="123")));

CREATE SHARDING TABLE RULE employee (
	    DATANODES("ds_${0..1}.employee_${0..1}"),
	    DATABASE_STRATEGY(TYPE="standard", SHARDING_COLUMN=user_id, SHARDING_ALGORITHM=database_inline),
	    TABLE_STRATEGY(TYPE="standard", SHARDING_COLUMN=emp_id, SHARDING_ALGORITHM= employee_inline),
	    KEY_GENERATE_STRATEGY(COLUMN=emp_id,KEY_GENERATOR= snowflake_key_generator));

