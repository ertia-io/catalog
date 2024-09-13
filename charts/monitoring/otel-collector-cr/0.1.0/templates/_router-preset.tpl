{{/*
Default router preset configuration
*/}}
{{- define "otel-collector-cr.routerBaseConfig" -}}
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
      send_batch_size: 8192
      send_batch_max_size: 8192
      timeout: 1s
{{- if .Values.router.routingList }}
    routing:
      default_exporters:
        - otlp/default-processor
{{- if .Values.router.addDebugExporters }}
        - otlp/debug-traces
        - otlp/debug-metrics
        - otlp/debug-logs
{{- end }}
      error_mode: ignore
      attribute_source: resource
      from_attribute: 'k8s.pod.label.logging.ertia.io/otel-processor-name'
      table:
{{- range .Values.router.routingList }}
        - value: {{ . }}
          exporters:
            - otel/{{ . }}
{{- end }}
{{- end }}

  exporters:
{{- if .Values.router.addDebugExporters }}
    otlp/debug-traces:
      endpoint: debug-traces-collector.monitoring.svc.cluster.local:4317
      tls:
        insecure: true
    otlp/debug-metrics:
      endpoint: debug-metrics-collector.monitoring.svc.cluster.local:4317
      tls:
        insecure: true
    otlp/debug-logs:
      endpoint: debug-logs-collector.monitoring.svc.cluster.local:4317
      tls:
        insecure: true
{{- end }}
{{- range .Values.router.routingList }}
    otlp/{{ .}}:
      endpoint: {{ . }}-collector.monitoring.svc.cluster.local:4317
      tls:
        insecure: true
{{- end }}
    otlp/default-processor:
      endpoint: default-processor-collector.monitoring.svc.cluster.local:4317
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
{{- if .Values.router.routingList }}
          - routing
{{- end }}
        exporters:
{{- if .Values.router.addDebugExporters }}
          - otlp/debug-traces
{{- end }}
{{- range .Values.router.routingList }}
          - otlp/{{ . }}
{{- end }}
          - otlp/default-processor
      metrics:
        receivers:
          - otlp
        processors:
          - memory_limiter
          - batch
{{- if .Values.router.routingList }}
          - routing
{{- end }}
        exporters:
{{- if .Values.router.addDebugExporters }}
          - otlp/debug-metrics
{{- end }}
{{- range .Values.router.routingList }}
          - otlp/{{ . }}
{{- end }}
          - otlp/default-processor
      logs:
        receivers:
          - otlp
        processors:
          - memory_limiter
          - batch
{{- if .Values.router.routingList }}
          - routing
{{- end }}
        exporters:
{{- if .Values.router.addDebugExporters }}
          - otlp/debug-logs
{{- end }}
{{- range .Values.router.routingList }}
          - otlp/{{ . }}
{{- end }}
          - otlp/default-processor
{{- end }}
