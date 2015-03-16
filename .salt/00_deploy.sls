{% set cfg = opts['ms_project'] %}
{% set data = cfg.data %}
cron:
  file.managed:
    - name: "{{cfg.data_root}}/dyndns"
    - contents: |
                #!/usr/bin/env bash
                {{cfg.project_root}}/gandi-dyndns --domain="{{data.domain}}" --api="{{data.token}}" {% for r in data.records %} --record="{{r}}"{% endfor %}
    - mode: 700
    - user: root
    - group: root

cron-up:
  file.managed:
    - name: /etc/cron.d/{{cfg.name}}gandidyndns
    - contents: |
                */10 * * * * root su root -c "{{cfg.data_root}}/dyndns" >/dev/null 2>&1
    - mode: 700
    - user: root
    - group: root
