{{/*
Default processor preset configuration
*/}}
{{- define "otel-collector-cr.processorBaseConfig" -}}
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
  {{- range $key, $val := .Values.processors }}
    {{ $key }}:
      {{ toYaml $val | nindent 6 }}
  {{- end }}
  exporters:
    otlp/exporter:
      endpoint: exporter-collector.monitoring.svc.cluster.local:4317
      tls:
        insecure: true
  service:
    pipelines:
      traces:
        receivers:
          - otlp
        processors:
          - memory_limiter
          - batch
        exporters:
          - otlp/exporter
      metrics:
        receivers:
          - otlp
        processors:
          - memory_limiter
          - batch
        exporters:
          - otlp/exporter
      logs:
        receivers:
          - otlp
        processors:
        {{- range $key, $val := .Values.processors }}
          - {{ $key }}
        {{- end }}
        exporters:
          - otlp/exporter
{{- end }}
