{{- define "zitadelConfigurator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "zitadelConfigurator.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "zitadelConfigurator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "zitadelConfigurator.labels" -}}
helm.sh/chart: {{ include "zitadelConfigurator.chart" . }}
{{ include "zitadelConfigurator.selectorLabels" . }}
app.kubernetes.io/version: {{ default .Values.image.tag .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "zitadelConfigurator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "zitadelConfigurator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "zitadelConfigurator.serviceAccountName" -}}
{{- if .Values.serviceAccount.enabled }}
{{- default (include "zitadelConfigurator.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "zitadelConfigurator.customDomain" -}}
  {{- if or (hasPrefix "https://" .Values.zitadelCustomDomain) (hasPrefix "http://" .Values.zitadelCustomDomain) }}
    {{- quote .Values.zitadelCustomDomain }}
  {{- else }}
    {{- quote (printf "https://%s" .Values.zitadelCustomDomain) }}
  {{- end }}
{{- end }}
