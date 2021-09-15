# Grapl Artifacts Buildkite Plugin

Encapsulates logic used in Grapl's release pipelines for
record-keeping around the versions of any artifacts that are
generated.

This is highly specific to how we run our CI/CD pipelines at Grapl; it
is not intended to be broadly generalizable.

## Example

```yml
steps:
  - label: ":gear::packer: Convert Packer Manifests"
    plugins:
      - grapl-security/grapl-artifacts#v0.1.0:
          action: convert_packer_manifests
```

```yml
steps:
  - label: ":knot: Merge Artifact Files"
    plugins:
      - grapl-security/grapl-artifacts#v0.1.0:
          action: merge_artifact_files
```

## Configuration

### action (required, string)

The name of the plugin action to run; currently supports the following:
- `convert_packer_manifests`
- `merge_artifact_files`

#### `convert_packer_manifests`

Extracts the AMI IDs from one or more Packer [manifest
files](https://www.packer.io/docs/post-processors/manifest) into a
simplified JSON form that we can consume more easily in downstream pipeline
jobs.

In particular, it will take a manifest file like this (call it
`my-ami.packer-manifest.json`):

```json
{
  "builds": [
    {
      "name": "amazon-linux-2-amd64-ami",
      "builder_type": "amazon-ebs",
      "build_time": 1626818948,
      "files": null,
      "artifact_id": "us-east-1:ami-aaaaaaaaaaaaaaaaa,us-east-2:ami-bbbbbbbbbbbbbbbbb,us-west-1:ami-ccccccccccccccccc,us-west-2:ami-ddddddddddddddddd",
      "packer_run_uuid": "f101f1dd-5fdb-bc9e-b0f0-ee49267bf567",
      "custom_data": null
    }
  ],
  "last_run_uuid": "f101f1dd-5fdb-bc9e-b0f0-ee49267bf567"
}
```

and turn it into `my-ami-${BUILDKITE_JOB_ID}.grapl-artifacts.json`:

```json
{
  "my-ami.us-east-1": "ami-aaaaaaaaaaaaaaaaa",
  "my-ami.us-east-2": "ami-bbbbbbbbbbbbbbbbb",
  "my-ami.us-west-1": "ami-ccccccccccccccccc",
  "my-ami.us-west-2": "ami-ddddddddddddddddd",
}
```

The manifest file _must_ have the extension `.packer-manifest.json`;
the resulting file will be named according to whatever the basename of
the manifest file is.

To generate manifests compatible with this plugin, use HCL like this
in your Packer template:

```hcl
build {
  # all your sources and provisioners go here...

  post-processor "manifest" {
    output = "my-ami.packer-manifest.json"
  }
}
```

All files previously uploaded using `buildkite-agent artifact upload`
in the current pipeline and ending in `.packer-manifest.json` will be
processed in this way; one `.grapl-artifacts.json` file per Packer
manifest will be generated and uploaded for access in downstream jobs.

#### `merge_artifact_files`

Takes all `*.grapl-artifacts.json` files that have been previously
uploaded in the current pipeline and merges them all into a single
file for subsequent processing.

Each file is assumed to contain a single, flat JSON object, with
mutually disjoint keys.

The final merged file is called `all_artifacts.json` and is uploaded
for access in downstream jobs.

## Building

Requires `make`, `docker`, and `docker-compose`.

`make all` will run all formatting, linting, and testing, though
finer-grained targets are available.
