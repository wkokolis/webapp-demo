# k8s_nodeport
  
This module creates a deployment and nodeport service, exposing the pod on the port specified.

## Providers

| Name | Version |
|------|---------|
| kubernetes | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| configmaps | A map of K8s configmaps available to the deployment.  The key is the volume name, and the value is the configmap's name. | `map` | `{}` | no |
| cpu\_ask | Minimum CPU units available per pod.  Expressed as millicores, where 1000 represents 100% of a single core/VPU. | `string` | `"250m"` | no |
| cpu\_limit | Upper limit on CPU available per pod. | `string` | `"1000m"` | no |
| environment\_variables | A map of one or more environment variables.  The key is the variable name, and the value is its value. | `map` | `{}` | no |
| external\_port | The port to publish the service on.  This must be between 30000 and 32767, and must be unique for the cluster. | `any` | n/a | yes |
| image | The container image to pull.  Do not include the registry, namespace, or tag, as these are provided independently. | `any` | n/a | yes |
| image\_pull | Should the image be pulled every time or not.  Can be 'Always', 'Never', or 'IfNotPresent'. | `string` | `"Always"` | no |
| internal\_port | The port that the service itself listens on.  Typically 8080 for Java, 5000 for Python, and 3000 for javascript. | `any` | n/a | yes |
| mem\_ask | Lower limit on memory available per pod.  Pods may use less, but will attempt to reserve this much. | `string` | `"128Mi"` | no |
| mem\_limit | Upper limit on memory available per pod.  Exceeding this limit will invoke the OOM killer. | `string` | `"1024Mi"` | no |
| namespace | Namespace in which to run the deployment. | `string` | `"default"` | no |
| persistent_volumes | A map of persistent volume claims for the deployment.  The key is the volume name, and the value is the pv's name. | `map` | `{}` | no |
| registry | The URI of the registry housing the image.  For DockerHub-based images, use the namespace for this value.  In a namespaced private registry, use both the URI and the namespace.  Do not confuse this with the K8s namespace! | `any` | n/a | yes |
| registry\_secret | K8s secret used to pull the image.  Unnecessary if using a service account with access to the secrets. | `any` | `null` | no |
| replicas | How many pods to run for this deployment. | `string` | `"1"` | no |
| secrets | A map of K8s secrets available to the deployment.  The key is the volume name, and the value is the secret's name. | `map` | `{}` | no |
| service\_account\_name | Service account to run the pods as.  Useful for granting access to cluster resources like secrets. | `any` | `null` | no |
| service\_name | Friendly name to identify the deployment.  Must be DNS-compliant (cannot contain underscores). | `any` | n/a | yes |
| tag | The image tag to deploy. | `string` | `"latest"` | no |
| volume\_mounts | A map of volumes and their mount points in the pods.  The key is the volume name, and the value is its path in the pods. | `map` | `{}` | no |

## Outputs

No output.

## Usage
At a minimum, you must supply the following required inputs:

- `external_port`
- `internal_port`
- `image`
- `registry`
- `service_name`
- `tag`

And one of either:
- `registry_secret`
- `service_account_name`

## Defining configurations and secrets
Pod configuration as defined by environment variables, configmaps, and secrets are all completely optional.

### Environment Variables
Environment variables are also expressed as key-value pairs.  The key is the variable name, and the value is its value.

For example:
```
module "thatService" {
  ...
  environment_variables = {
    SERVICE = "web-frontend"
    GIT_COMMIT = "v0.1.4"
    SPRING_PROFILES_ACTIVE = "dev"
  }
```

### Setting up configmaps and secrets
Configmaps and secrets are expressed in your plan as key-value pairs.  For either type, the key represents the name of the volume that will be created for the pods.  The value is the actual K8s configmap or secret.

For each configmap or secret you need a corresponding key-value pair in the `volume_mounts` map.  Here the key is also the name of the volume, and the value represents the filesystem path where it will be mounted.

For example:
```
module "thisService" {
  ...
  configmaps = {
    config = "webapp-properties"
  }
  secrets = {
    dbcreds = "rds-instance-credentials"
    certs = "ssl-certificates"
  }
  persistent_volumes = {
    storage = "pv-storage"
  }
  volume_mounts = {
    config = "/etc/httpd/conf.d/vhosts"
    dbcreds = "/run/secrets"
    certs = "/etc/httpd/conf/ssl"
    storage = "/var/www/html/storage"
  }
```

If you do not specify the volume mount key-value pair, the data will not be present in the pod!

### Local volumes
You can also use the `volume_mounts` map to specify host or persistent volumes.
