{% from "salt-minion/map.jinja" import salt_minion with context %}

/etc/apt/keyrings:
    file.directory:
        - makedirs: true

/etc/apt/keyrings/salt-archive-keyring.pgp:
    file.managed:
        - source: https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public
        - source_hash: 36decef986477acb8ba2a1fc4041bcf9f22229ef6c939d0317c9e36a9d142b34
        - mode: '0644'

saltstack_repo:
    pkgrepo.managed:
        - humanname: SaltStack Broadcom repository
        - name: deb [signed-by=/etc/apt/keyrings/salt-archive-keyring.pgp] https://packages.broadcom.com/artifactory/saltproject-deb stable main
        - file: /etc/apt/sources.list.d/saltstack.list
        - require:
            - file: /etc/apt/keyrings/salt-archive-keyring.pgp
        - require_in:
            - salt_package

salt_packages:
    pkg.installed:
        - pkgs:
            - salt-minion

minion_service:
    service.running:
        - name: salt-minion
        - enable: True

/etc/salt/minion:
    file.append:
        - text:
            "master: {{ salt_minion.master }}"
        - watch_in:
            - minion_service
