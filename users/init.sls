{% from "users/map.jinja" import users with context %}

admin:
  group.present:
    - gid: 1100

{% for user, args in users.items() %}

{{ user }}:
  group.present:
    - gid: {{ args['gid'] }}
  user.present:
    - home: {{ args['home'] }}
    - shell: {{ args['shell'] }}
    - allow_uid_change: True
    - uid: {{ args['uid'] }}
    - gid: {{ args['gid'] }}
{% if 'password' in args %}
    - password: {{ args['password'] }}
{% if 'enforce_password' in args %}
    - enforce_password: {{ args['enforce_password'] }}
{% endif %}
{% endif %}
    - fullname: {{ args['fullname'] }}
{% if 'groups' in args %}
    - groups: {{ args['groups'] }}
{% endif %}
    - require:
      - group: {{ user }}

{% if 'key.pub' in args %}
{{ user }}_key.pub:
  ssh_auth.manage:
    - user: {{ user }}
    - ssh_keys:                                   
      - {{ args['key.pub'] }}
{% endif %}

{% endfor %}
