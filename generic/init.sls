{% from "generic/map.jinja" import generic with context %}

# prohibit root login
set_root_access:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: '^#?PermitRootLogin.*'
    - repl: 'PermitRootLogin no'
    - append_if_not_found: True

# install sudo
sudo:
  pkg.installed: []

/etc/motd:
  file.managed:
    - source: salt://generic/files/motd
