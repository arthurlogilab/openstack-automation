keystone: 
  pkg: 
    - installed
  service: 
    - running
    - watch: 
      - pkg: keystone
      - ini: keystone
  file: 
    - managed
    - name: /etc/keystone/keystone.conf
    - user: root
    - group: root
    - mode: 644
    - require: 
      - pkg: keystone
  ini: 
    - options_present
    - name: /etc/keystone/keystone.conf
    - sections: 
      DEFAULT: 
        admin_token: {{ pillar['keystone.token'] }}
      database: 
        connection: mysql://{{ pillar['mysql'][pillar['services']['keystone']['db_name']]['username'] }}:{{ pillar['mysql'][pillar['services']['keystone']['db_name']]['password'] }}@{{ salt['cluster_ops.get_candidate']('mysql') }}/{{ pillar['services']['keystone']['db_name'] }}
    - require: 
      - file: keystone
keystone_sync: 
  cmd: 
    - run
    - name: {{ pillar['services']['keystone']['db_sync'] }}
    - require: 
      - service: keystone
keystone_sqlite_delete: 
  file: 
    - absent
    - name: /var/lib/keystone/keystone.sqlite
    - require: 
      - pkg: keystone
