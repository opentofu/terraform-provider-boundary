# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

schema = 1
artifacts {
  # This should match the `matrix` in .github/workflows/build.yml
  zip = [
    "terraform-provider-boundary_${version}_darwin_amd64.zip",
    "terraform-provider-boundary_${version}_darwin_arm64.zip",
    "terraform-provider-boundary_${version}_freebsd_386.zip",
    "terraform-provider-boundary_${version}_freebsd_amd64.zip",
    "terraform-provider-boundary_${version}_freebsd_arm.zip",
    "terraform-provider-boundary_${version}_linux_386.zip",
    "terraform-provider-boundary_${version}_linux_amd64.zip",
    "terraform-provider-boundary_${version}_linux_arm.zip",
    "terraform-provider-boundary_${version}_linux_arm64.zip",
    "terraform-provider-boundary_${version}_windows_386.zip",
    "terraform-provider-boundary_${version}_windows_amd64.zip",
  ]
}
