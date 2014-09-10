neutron-plugin-openvswitch-agent: 
  pkg: 
    - installed
  service: 
    - running
    - watch: 
      - pkg: neutron-plugin-openvswitch-agent
      - ini: neutron-ovs-conf
      - ini: neutron-plugin-ml2
neutron-ovs-conf: 
  file: 
    - managed
    - name: /etc/neutron/neutron.conf
    - group: neutron
    - user: neutron
    - mode: 644
    - require: 
      - pkg: neutron-plugin-openvswitch-agent
  ini: 
    - options_present
    - name: /etc/neutron/neutron.conf
    - sections: 
        DEFAULT: 
          rabbit_host: {{ salt['cluster_ops.get_candidate']('queue.' + pillar['queue-engine']) }}
          neutron_metadata_proxy_shared_secret: {{ pillar['neutron']['metadata_secret'] }}
          service_neutron_metadata_proxy: true
          auth_strategy: keystone
          rpc_backend: neutron.openstack.common.rpc.impl_kombu
          core_plugin: neutron.plugins.ml2.plugin.Ml2Plugin
          service_plugins: neutron.services.l3_router.l3_router_plugin.L3RouterPlugin
          allow_overlapping_ips: True
          verbose: True
        keystone_authtoken: 
          auth_protocol: http
          admin_user: neutron
          admin_password: {{ pillar['keystone']['tenants']['service']['users']['neutron']['password'] }}
          auth_host: {{ salt['cluster_ops.get_candidate']('keystone') }}
          auth_uri: http://{{ salt['cluster_ops.get_candidate']('keystone') }}:5000
          admin_tenant_name: service
          auth_port: 35357
    - require: 
        - file: neutron-ovs-conf
openvswitch-switch: 
  pkg: 
    - installed
  service: 
    - running
    - require: 
      - pkg: openvswitch-switch
