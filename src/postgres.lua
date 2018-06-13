return {
  {
    name = "2018-06-13-105303_create_billing_tables",
    up = [[
      create table consumer_apis(
        id  uuid not null  constraint consumer_apis_pkey primary key,
        consumer_id uuid
        constraint consumer_apis_consumers_id_fk references consumers on delete cascade,
        api_id  uuid  constraint consumer_apis_apis_id_fk  references apis on delete cascade
      );
      create unique index consumer_apis_consumer_id_api_id_uindex on consumer_apis (consumer_id, api_id);

      CREATE TABLE billing_base_rules (id serial PRIMARY KEY, account_ammount_limit int NOT NULL , price_per_account int NULL , abort boolean NOT NULL DEFAULT false , price_per_month int NULL, billing_type varchar(255) NOT NULL , active boolean NOT NULL DEFAULT false , created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL);

      CREATE TABLE billing_base_url_rules (id serial PRIMARY KEY, url varchar(255) NOT NULL, price_per_unit int NULL, usage_limit_per_month int NOT NULL, account_ammount_limit int NOT NULL , name varchar(255) NULL, billing_base_rule_id int NOT NULL);

      ALTER TABLE billing_base_url_rules ADD CONSTRAINT billing_base_url_rules_billing_base_rule_id_foreign FOREIGN KEY (billing_base_rule_id) REFERENCES billing_base_rules (id) ON  DELETE CASCADE;

      CREATE TABLE billing_customer_rules (id serial PRIMARY KEY, started_at timestamp NOT NULL, expired_at timestamp NOT NULL, billing_type varchar(255) NOT NULL , abort boolean NOT NULL DEFAULT false, account_ammount_limit int NOT NULL, balance int NOT NULL, customer_id varchar(255) NOT NULL, created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL);

      CREATE TABLE billing_customer_url_rules (id serial PRIMARY KEY, url varchar(255) NOT NULL, name varchar(255) NULL, price_per_unit int NULL , usage_limit_per_month int NOT NULL, called int NOT NULL, billing_customer_rule_id int NULL);

      ALTER TABLE billing_customer_url_rules ADD CONSTRAINT billing_customer_url_rules_billing_customer_rule_id_foreign FOREIGN KEY (billing_customer_rule_id) REFERENCES billing_customer_rules (id) ON DELETE CASCADE;
    ]],
    down = [[
      DROP TABLE consumer_apis;
      DROP TABLE billing_base_url_rules;
      DROP TABLE billing_base_rules;
      DROP TABLE billing_customer_url_rules;
      DROP TABLE billing_customer_rules;
    ]]
  }
}