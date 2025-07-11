---
# generated by https://github.com/hashicorp/terraform-plugin-docs
page_title: "boundary_target Resource - terraform-provider-boundary"
subcategory: ""
description: |-
  The target resource allows you to configure a Boundary target.
---

# boundary_target (Resource)

The target resource allows you to configure a Boundary target.

## Example Usage

```terraform
resource "boundary_scope" "global" {
  global_scope = true
  scope_id     = "global"
}

resource "boundary_scope" "org" {
  name                     = "organization_one"
  description              = "My first scope!"
  scope_id                 = boundary_scope.global.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}

resource "boundary_scope" "project" {
  name                   = "project_one"
  description            = "My first scope!"
  scope_id               = boundary_scope.org.id
  auto_create_admin_role = true
}

resource "boundary_credential_store_vault" "foo" {
  name        = "vault_store"
  description = "My first Vault credential store!"
  address     = "http://127.0.0.1:8200"      # change to Vault address
  token       = "s.0ufRo6XEGU2jOqnIr7OlFYP5" # change to valid Vault token
  scope_id    = boundary_scope.project.id
}

resource "boundary_credential_library_vault" "foo" {
  name                = "foo"
  description         = "My first Vault credential library!"
  credential_store_id = boundary_credential_store_vault.foo.id
  path                = "my/secret/foo" # change to Vault backend path
  http_method         = "GET"
  credential_type     = "username_password"
}

resource "boundary_host_catalog" "foo" {
  name        = "test"
  description = "test catalog"
  scope_id    = boundary_scope.project.id
  type        = "static"
}

resource "boundary_host" "foo" {
  type            = "static"
  name            = "foo"
  host_catalog_id = boundary_host_catalog.foo.id
  address         = "10.0.0.1"
}

resource "boundary_host" "bar" {
  type            = "static"
  name            = "bar"
  host_catalog_id = boundary_host_catalog.foo.id
  address         = "10.0.0.1"
}

resource "boundary_host_set" "foo" {
  type            = "static"
  name            = "foo"
  host_catalog_id = boundary_host_catalog.foo.id

  host_ids = [
    boundary_host.foo.id,
    boundary_host.bar.id,
  ]
}

resource "boundary_storage_bucket" "aws_example" {
  name            = "My aws storage bucket"
  description     = "My first storage bucket!"
  scope_id        = boundary_scope.org.id
  plugin_name     = "aws"
  bucket_name     = "mybucket"
  attributes_json = jsonencode({ "region" = "us-east-1" })
  secrets_json = jsonencode({
    "access_key_id"     = "aws_access_key_id_value",
    "secret_access_key" = "aws_secret_access_key_value"
  })
  worker_filter = "\"pki\" in \"/tags/type\""
}

resource "boundary_target" "foo" {
  name         = "foo"
  description  = "Foo target"
  type         = "tcp"
  default_port = "22"
  scope_id     = boundary_scope.project.id
  host_source_ids = [
    boundary_host_set.foo.id
  ]
  brokered_credential_source_ids = [
    boundary_credential_library_vault.foo.id
  ]
}

resource "boundary_target" "ssh_foo" {
  name         = "ssh_foo"
  description  = "Ssh target"
  type         = "ssh"
  default_port = "22"
  scope_id     = boundary_scope.project.id
  host_source_ids = [
    boundary_host_set.foo.id
  ]
  injected_application_credential_source_ids = [
    boundary_credential_library_vault.foo.id
  ]
}

resource "boundary_target" "ssh_session_recording_foo" {
  name         = "ssh_foo"
  description  = "Ssh target"
  type         = "ssh"
  default_port = "22"
  scope_id     = boundary_scope.project.id
  host_source_ids = [
    boundary_host_set.foo.id
  ]
  injected_application_credential_source_ids = [
    boundary_credential_library_vault.foo.id
  ]
  enable_session_recording = true
  storage_bucket_id        = boundary_storage_bucket.aws_example
}

resource "boundary_target" "address_foo" {
  name         = "address_foo"
  description  = "Foo target with an address"
  type         = "tcp"
  default_port = "22"
  scope_id     = boundary_scope.project.id
  address      = "127.0.0.1"
}
```

<!-- schema generated by tfplugindocs -->
## Schema

### Required

- `scope_id` (String) The scope ID in which the resource is created. Defaults to the provider's `default_scope` if unset.
- `type` (String) The target resource type.

### Optional

- `address` (String) Optionally, a valid network address to connect to for this target. Cannot be used alongside host_source_ids.
- `brokered_credential_source_ids` (Set of String) A list of brokered credential source ID's.
- `default_client_port` (Number) The default client port for this target.
- `default_port` (Number) The default port for this target.
- `description` (String) The target description.
- `egress_worker_filter` (String) Boolean expression to filter the workers used to access this target
- `enable_session_recording` (Boolean) HCP/Ent Only. Enable sessions recording for this target. Only applicable for SSH targets.
- `host_source_ids` (Set of String) A list of host source ID's. Cannot be used alongside address.
- `ingress_worker_filter` (String) HCP Only. Boolean expression to filter the workers a user will connect to when initiating a session against this target
- `injected_application_credential_source_ids` (Set of String) A list of injected application credential source ID's.
- `name` (String) The target name. Defaults to the resource name.
- `session_connection_limit` (Number)
- `session_max_seconds` (Number)
- `storage_bucket_id` (String) HCP/Ent Only. Storage bucket for this target. Only applicable for SSH targets.
- `worker_filter` (String, Deprecated) Boolean expression to filter the workers for this target

### Read-Only

- `id` (String) The ID of the target.

## Import

Import is supported using the following syntax:

The [`terraform import` command](https://developer.hashicorp.com/terraform/cli/commands/import) can be used, for example:

```shell
terraform import boundary_target.foo <my-id>
```
