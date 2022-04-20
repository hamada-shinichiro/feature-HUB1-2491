
resource "aws_ssm_parameter" "server_port" {
  name        = "/Env/${var.env}/SERVER_PORT"
  value       = "8080"
  type        = "String"
  description = "サーバーHTTPポート番号指定"
  overwrite   = "true"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "db_url" {
  name        = "/Env/${var.env}/DB_URL"
  value       = "jdbc:postgresql://localhost:5432/postgres?socketTimeout=5"
  type        = "String"
  description = "DB接続用URL"
  overwrite   = "true"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "db_userName" {
  name        = "/Env/${var.env}/DB_USERNAME"
  value       = "postgres"
  type        = "String"
  description = "DB接続用ユーザ名"
  overwrite   = "true"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/Env/${var.env}/DB_PASSWORD"
  value       = "postgres"
  type        = "SecureString"
  description = "DB接続パスワード"
  overwrite   = "true"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "apiauthentication_dynamic_apiauthenticationdynamic_target_100_value" {
  name        = "/Env/${var.env}/APIAUTHENTICATION_DYNAMIC_APIAUTHENTICATIONDYNAMIC_TARGET_100_VALUE"
  value       = "nc_api_key_value"
  type        = "String"
  description = "共通部品API認証で利用するvalue値(NC)"
  overwrite   = "true"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "apiauthentication_dynamic_apiauthenticationdynamic_target_200_value" {
  name        = "/Env/${var.env}/APIAUTHENTICATION_DYNAMIC_APIAUTHENTICATIONDYNAMIC_TARGET_200_VALUE"
  value       = "cb_api_key_value"
  type        = "String"
  description = "共通部品API認証で利用するvalue値(CB)"
  overwrite   = "true"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "apiauthentication_dynamic_apiauthenticationdynamic_target_201_value" {
  name        = "/Env/${var.env}/APIAUTHENTICATION_DYNAMIC_APIAUTHENTICATIONDYNAMIC_TARGET_201_VALUE"
  value       = "poc_api_key_value"
  type        = "String"
  description = "共通部品API認証で利用するvalue値(Poc)"
  overwrite   = "true"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "interfacelog_static_logmask_mask" {
  name        = "/Env/${var.env}/INTERFACELOG_STATIC_LOGMASK_MASK"
  value       = "false"
  type        = "String"
  description = "共通部品通信ログ出力で利用する個人情報マスク有無の定義"
  overwrite   = "true"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "orderrcv_static_webhook_url" {
  name        = "/Env/${var.env}/ORDERRCV_STATIC_WEBHOOK_URL"
  value       = "localhost:8080"
  type        = "String"
  description = "お届け開始通知、及びお届け結果通知を配送HUBが受け取るAPIエンドポイントのドメイン"
  overwrite   = "true"

  lifecycle {
    ignore_changes = [value]
  }
}
resource "aws_ssm_parameter" "getapikey_dynamic_getapikeydynamic_target_orderrcv200_apikey" {
  name        = "/Env/${var.env}/GETAPIKEY_DYNAMIC_GETAPIKEYDYNAMIC_TARGET_ORDERRCV200_APIKEY"
  value       = "ORDERRCV200_APIKEY"
  type        = "String"
  description = "注文ステータス連携API（CB）呼出時に使用するAPIキー"
  overwrite   = "true"

  lifecycle {
    ignore_changes = [value]
  }
}


resource "aws_ssm_parameter" "getapikey_dynamic_getapikeydynamic_target_orderrcv201_apikey" {
  name        = "/Env/${var.env}/GETAPIKEY_DYNAMIC_GETAPIKEYDYNAMIC_TARGET_ORDERRCV201_APIKEY"
  value       = "ORDERRCV201_APIKEY"
  type        = "String"
  description = "注文ステータス連携API（品川PoC）呼出時に使用するAPIキー"
  overwrite   = "true"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "getapikey_dynamic_getapikeydynamic_target_deliveryrcv100_apikey" {
  name        = "/Env/${var.env}/GETAPIKEY_DYNAMIC_GETAPIKEYDYNAMIC_TARGET_DELIVERYRCV100_APIKEY"
  value       = "DELIVERYRCV100_APIKEY"
  type        = "String"
  description = "配送ステータス連携API（NC）呼出時に使用するAPIキー"
  overwrite   = "true"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "getapikey_dynamic_getapikeydynamic_target_ordercancel200_apikey" {
  name        = "/Env/${var.env}/GETAPIKEY_DYNAMIC_GETAPIKEYDYNAMIC_TARGET_ORDERCANCEL200_APIKEY"
  value       = "ORDERCANCEL200_APIKEY"
  type        = "String"
  description = "注文キャンセル連携API（CB）呼出時に使用するAPIキー"
  overwrite   = "true"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "getapikey_dynamic_getapikeydynamic_target_ordercancel201_apikey" {
  name        = "/Env/${var.env}/GETAPIKEY_DYNAMIC_GETAPIKEYDYNAMIC_TARGET_ORDERCANCEL201_APIKEY"
  value       = "ORDERCANCEL201_APIKEY"
  type        = "String"
  description = "注文キャンセル連携API（品川PoC）呼出時に使用するAPIキー"
  overwrite   = "true"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "callapicommon_dynamic_callapicommondynamic_target_orderrcv200_endpoint" {
  name        = "/Env/${var.env}/CALLAPICOMMON_DYNAMIC_CALLAPICOMMONDYNAMIC_TARGET_ORDERRCV200_ENDPOINT"
  value       = "http://localhost:3000/test/"
  type        = "String"
  description = "注文ステータス連携API（CB）にアクセスするエンドポイント情報（URI）"
  overwrite   = "true"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "callapicommon_dynamic_callapicommondynamic_target_orderrcv201_endpoint" {
  name        = "/Env/${var.env}/CALLAPICOMMON_DYNAMIC_CALLAPICOMMONDYNAMIC_TARGET_ORDERRCV201_ENDPOINT"
  value       = "http://localhost:3000/test/"
  type        = "String"
  description = "注文ステータス連携API（品川PoC）にアクセスするエンドポイント情報（URI）"
  overwrite   = "true"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "callapicommon_dynamic_callapicommondynamic_target_deliveryrcv100_endpoint" {
  name        = "/Env/${var.env}/CALLAPICOMMON_DYNAMIC_CALLAPICOMMONDYNAMIC_TARGET_DELIVERYRCV100_ENDPOINT"
  value       = "http://localhost:3000/test/"
  type        = "String"
  description = "配送ステータス連携API（NC）にアクセスするエンドポイント情報（URI）"
  overwrite   = "true"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "callapicommon_dynamic_callapicommondynamic_target_ordercancel200_endpoint" {
  name        = "/Env/${var.env}/CALLAPICOMMON_DYNAMIC_CALLAPICOMMONDYNAMIC_TARGET_ORDERCANCEL200_ENDPOINT"
  value       = "http://localhost:3000/test/"
  type        = "String"
  description = "注文キャンセル連携API（CB）にアクセスするエンドポイント情報（URI）"
  overwrite   = "true"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "callapicommon_dynamic_callapicommondynamic_target_ordercancel201_endpoint" {
  name        = "/Env/${var.env}/CALLAPICOMMON_DYNAMIC_CALLAPICOMMONDYNAMIC_TARGET_ORDERCANCEL201_ENDPOINT"
  value       = "http://localhost:3000/test/"
  type        = "String"
  description = "注文キャンセル連携API（品川PoC）にアクセスするエンドポイント情報（URI）"
  overwrite   = "true"

  lifecycle {
    ignore_changes = [value]
  }
}
