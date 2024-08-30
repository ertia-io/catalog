{{- /*
    https://github.com/jupyterhub/zero-to-jupyterhub-k8s/blob/2.0.0/jupyterhub/templates/hub/_helpers-passwords.tpl#L16-L32
    Returns given number of random Hex characters.
    - randNumeric 4 | atoi generates a random number in [0, 10^4)
      This is a range evenly divisble by 16, but even if off by one,
      that last partial interval offsetting randomness is only 1 part in 625.
    - mod N 16 maps to the range 0-15
    - printf "%x" represents a single number 0-15 as a single hex character
*/}}
{{- define "randgen.randHex" -}}
    {{- $result := "" }}
    {{- range $i := until . }}
        {{- $rand_hex_char := mod (randNumeric 4 | atoi) 16 | printf "%x" }}
        {{- $result = print $result $rand_hex_char }}
    {{- end }}
    {{- $result }}
{{- end }}
