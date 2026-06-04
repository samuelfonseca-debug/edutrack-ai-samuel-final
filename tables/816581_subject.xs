// Stores academic subjects owned by a user and associated with an account.
table subject {
  auth = false

  schema {
    int id
    timestamp created_at?=now {
      visibility = "private"
    }
    timestamp updated_at?=now {
      visibility = "private"
    }

    int user_id {
      table = "user"
    }

    int account_id? {
      table = "account"
    }

    text nome filters=trim
    text codigo? filters=trim
    text descricao? filters=trim
    int creditos?
    int semestre?
    bool ativo?=true
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "user_id", op: "asc"}]}
    {type: "btree", field: [{name: "account_id", op: "asc"}, {name: "ativo", op: "asc"}]}
    {type: "btree", field: [{name: "codigo", op: "asc"}]}
  ]

  tags = ["xano:quick-start"]
}
