# Examples of chart configuration

Here is a collection of common configurations for the OpenTelemetry demo.  Each folder contains an example `values.yaml` and the resulting configurations that are generated by the opentelemetry-demo helm charts.

- [Default configuration](default)
- [Bring your own Observability](bring-your-own-observability)
- [Collector as a Daemonset](collector-as-daemonset)
- [Custom Environment Variables](custom-environment-variables)
- [Kubernetes Infrastructure Monitoring](kubernetes-infra-monitoring)
- [Public Hosted Ingress](public-hosted-ingress)

The manifests are rendered using the `helm template` command and the specific example folder's values.yaml.
