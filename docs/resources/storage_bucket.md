---
# generated by https://github.com/hashicorp/terraform-plugin-docs
page_title: "boundary_storage_bucket Resource - terraform-provider-boundary"
subcategory: ""
description: |-
  The storage bucket resource allows you to configure a Boundary storage bucket. A storage bucket can only belong to the Global scope or an Org scope. At this time, the only supported storage for storage buckets is AWS S3. This feature requires Boundary Enterprise or Boundary HCP.
---

# boundary_storage_bucket (Resource)

The storage bucket resource allows you to configure a Boundary storage bucket. A storage bucket can only belong to the Global scope or an Org scope. At this time, the only supported storage for storage buckets is AWS S3. This feature requires Boundary Enterprise or Boundary HCP.

## Example Usage

```terraform
resource "boundary_scope" "org" {
  name                     = "organization_one"
  description              = "My first scope!"
  scope_id                 = boundary_scope.global.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}

resource "boundary_storage_bucket" "aws_static_credentials_example" {
  name            = "My aws storage bucket with static credentials"
  description     = "My first storage bucket!"
  scope_id        = boundary_scope.org.id
  plugin_name     = "aws"
  bucket_name     = "mybucket"
  attributes_json = jsonencode({ "region" = "us-east-1" })

  # recommended to pass in aws secrets using a file() or using environment variables
  # the secrets below must be generated in aws by creating a aws iam user with programmatic access
  secrets_json = jsonencode({
    "access_key_id"     = "aws_access_key_id_value",
    "secret_access_key" = "aws_secret_access_key_value"
  })
  worker_filter = "\"pki\" in \"/tags/type\""
}

resource "boundary_storage_bucket" "aws_dynamic_credentials_example" {
  name        = "My aws storage bucket with dynamic credentials"
  description = "My first storage bucket!"
  scope_id    = boundary_scope.org.id
  plugin_name = "aws"
  bucket_name = "mybucket"

  # the role_arn value should be the same arn used as the instance profile that is attached to the ec2 instance
  # https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html
  attributes_json = jsonencode({
    "region"                      = "us-east-1"
    "role_arn"                    = "arn:aws:iam::123456789012:role/S3Access"
    "disable_credential_rotation" = "true"
  })
  worker_filter = "\"pki\" in \"/tags/type\""
}
```

<!-- schema generated by tfplugindocs -->
## Schema

### Required

- `bucket_name` (String) The name of the bucket within the external object store service.
- `scope_id` (String) The scope for this storage bucket.
- `worker_filter` (String) Filters to the worker(s) that can handle requests for this storage bucket. The filter must match an existing worker in order to create a storage bucket.

### Optional

- `attributes_json` (String) The attributes for the storage bucket. The "region" attribute field is required when creating an AWS storage bucket. Values are either encoded with the "jsonencode" function, pre-escaped JSON string, or a file:// or env:// path. Set to a string "null" or remove the block to clear all attributes in the storage bucket.
- `bucket_prefix` (String) The prefix used to organize the data held within the external object store.
- `description` (String) The storage bucket description.
- `name` (String) The storage bucket name. Defaults to the resource name.
- `plugin_id` (String) The ID of the plugin that should back the resource. This or plugin_name must be defined.
- `plugin_name` (String) The name of the plugin that should back the resource. This or plugin_id must be defined.
- `secrets_json` (String, Sensitive) The secrets for the storage bucket. Either values encoded with the "jsonencode" function, pre-escaped JSON string, or a file:// or env:// path. Set to a string "null" to clear any existing values. NOTE: Unlike "attributes_json", removing this block will NOT clear secrets from the storage bucket; this allows injecting secrets for one call, then removing them for storage.

### Read-Only

- `id` (String) The ID of the storage bucket.
- `internal_force_update` (String) Internal only. Used to force update so that we can always check the value of secrets.
- `internal_hmac_used_for_secrets_config_hmac` (String) Internal only. The Boundary-provided HMAC used to calculate the current value of the HMAC'd config. Used for drift detection.
- `internal_secrets_config_hmac` (String) Internal only. HMAC of (serverSecretsHmac + config secrets). Used for proper secrets handling.
- `secrets_hmac` (String) The HMAC'd secrets value returned from the server.

## Import

Import is supported using the following syntax:

The [`terraform import` command](https://developer.hashicorp.com/terraform/cli/commands/import) can be used, for example:

```shell
terraform import boundary_storage_bucket.foo <my-id>
```
