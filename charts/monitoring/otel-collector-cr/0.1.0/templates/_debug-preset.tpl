{{/*
Default debug preset configuration
*/}}
{{- define "otel-collector-cr.debugBaseConfig" -}}
  mode: deployment
  config:
    receivers:
      otlp:
        protocols:
          grpc:
            endpoint: 0.0.0.0:4317
          http:
            endpoint: 0.0.0.0:4318
    processors:
      memory_limiter:
        check_interval: 1s
        limit_percentage: 90
        spike_limit_percentage: 50
      batch:
        send_batch_size: 1000
        timeout: 1s

    exporters:
      debug/traces:
        verbosity: detailed
        sampling_initial: 1
        sampling_thereafter: 20
      debug/metrics:
        verbosity: detailed
        sampling_initial: 1
        sampling_thereafter: 20
      debug/logs:
        verbosity: detailed
        sampling_initial: 5
        sampling_thereafter: 10

    service:
      pipelines:
        traces:
          receivers: [otlp]
          processors: [memory_limiter, batch]
          exporters: [debug/traces]
        metrics:
          receivers: [otlp]
          processors: [memory_limiter, batch]
          exporters: [debug/metrics]
        logs:
          receivers: [otlp]
          processors: [memory_limiter, batch]
          exporters: [debug/logs]
{{- end }}
