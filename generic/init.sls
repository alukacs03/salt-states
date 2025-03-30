{% from "generic/map.jinja" import generic with context %}

sshd:
  service.running: []

# prohibit root login
set_root_access:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: '^#?PermitRootLogin.*'
    - repl: 'PermitRootLogin no'
    - append_if_not_found: True
    - watch_in:
        service: sshd
# install sudo
sudo:
  pkg.installed: []

/etc/motd:
  file.managed:
    - source: salt://generic/files/motd
