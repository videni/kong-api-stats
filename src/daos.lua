local baseRuleSchema = {
  primary_key = {"id"},
  table = "billing_base_rules", 
  fields = {
    id = {type = "id", dao_insert_value = true},
    account_ammount_limit = {type = "integer"},
    price_per_account = {type = "integer"},
    abort = {type = "boolean"},
    created_at = {type = "timestamp", immutable = true, dao_insert_value = true},
    consumer_id = {type = "id", required = true, foreign = "consumers:id"}, 
    billing_type = {type = "string"},
    active = {type = "boolean", default = false},
  }
}

local baseUrlRuleSchema = {
  primary_key = {"id"},
  table = "billing_base_url_rules",
  fields = {
    id = {type = "id", dao_insert_value = true},
    url = {type = "string"},
    price_per_unit = {type = "integer"},
    usage_limit_per_month = {type = "integer"},
    account_ammount_limit = {type = "integer"},
    name = {type = "string"},
    billing_base_rule_id = {type = "id", required = true, foreign = "billing_base_rules:id"}, 
  }
}

local customerRuleSchema = {
  primary_key = {"id"},
  table = "billing_customer_rules",
  fields = {
    id = {type = "id", dao_insert_value = true},
    account_ammount_limit = {type = "integer"},
    abort = {type = "boolean"},
    started_at = {type = "timestamp"},
    expired_at = {type = "timestamp"},
    balance = {type = "integer"},
    consumer_id = {type = "id", required = true, foreign = "consumers:id"}, 
    billing_type = {type = "string"},
  }
}

local customerUrlRuleSchema = {
  primary_key = {"id"},
  table = "billing_customer_url_rules",
  fields = {
    id = {type = "id", dao_insert_value = true},
    url = {type = "string"},
    price_per_unit = {type = "integer"},
    usage_limit_per_month = {type = "integer"},
    account_ammount_limit = {type = "integer"},
    name = {type = "string"},
    billing_customer_rule_id = {type = "id", required = true, foreign = "billing_customer_rules:id"}, 
  }
}

return {
	billing_base_rules = baseRuleSchema,
	billing_base_url_rules = baseUrlRuleSchema,
	billing_customer_rules = customerRuleSchema,
	billing_customer_url_rules = customerUrlRuleSchema,
}