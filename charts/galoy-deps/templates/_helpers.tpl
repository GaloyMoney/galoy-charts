{{/*
Expand the name of the chart.
*/}}
{{- define "galoy-deps.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "galoy-deps.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "galoy-deps.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "galoy-deps.labels" -}}
helm.sh/chart: {{ include "galoy-deps.chart" . }}
{{ include "galoy-deps.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "galoy-deps.selectorLabels" -}}
app.kubernetes.io/name: {{ include "galoy-deps.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "galoy-deps.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "galoy-deps.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Render tunnelConnector.upstreams as a TUNNEL_UPSTREAMS env value:
  "name1=url1,name2=url2,..."
Consumed by templates/tunnel-connector-deployment.yaml — matches the
`name=url,name=url` format the drua `tunnel-connector` binary parses
via its `--upstreams` / `TUNNEL_UPSTREAMS` arg.
*/}}
{{- define "galoy-deps.tunnelConnector.upstreamsEnv" -}}
{{- $parts := list -}}
{{- range .Values.tunnelConnector.upstreams -}}
{{- $parts = append $parts (printf "%s=%s" .name .url) -}}
{{- end -}}
{{- join "," $parts -}}
{{- end }}
