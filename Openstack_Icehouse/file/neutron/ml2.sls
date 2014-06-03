neutron-plugin-ml2:
  pkg:
    - installed
  file:
    - managed
    - name: /etc/neutron/plugins/ml2/ml2_conf.ini
    - user: neutron
    - group: neutron
    - mode: 644
    - require:
      - pkg: neutron-plugin-ml2
  ini:
    - options_present
    - name: /etc/neutron/plugins/ml2/ml2_conf.ini
    - sections:
        ml2:
          type_drivers: {{ ','.join(pillar['neutron']['type_drivers']) }}
          tenant_network_types: {{ ','.join(pillar['neutron']['tenant_network_types']) }}
          mechanism_drivers: openvswitch
        ovs:
{% if pillar['neutron']['intergration_bridge'] != 'br-int' %}
          intergration_bridge: {{ pillar['neutron']['intergration_bridge'] }}
{% endif %}
{% if 'flat' in pillar['neutron']['type_drivers'] or 'vlan' in pillar['neutron']['type_drivers'] %}
          bridge_mappings: {{  salt['cluster_ops.get_bridge_mappings']()  }}
{% endif %}
{% if 'gre' in pillar['neutron']['type_drivers'] %}
          tunnel_type: gre
          enable_tunneling: True
          local_ip: {{ pillar['hosts'][grains['id']] }}
{% endif %}
{% if 'vxlan' in pillar['neutron']['type_drivers'] %}
          tunnel_type: vxlan
          enable_tunneling: True
          local_ip: {{ pillar['hosts'][grains['id']] }}
{% endif %}
{% if 'flat' in pillar['neutron']['type_drivers'] and grains['id'] in pillar['neutron']['type_drivers']['flat'] %}
        ml2_type_flat:
          flat_networks: {{ ','.join(pillar['neutron']['type_drivers']['flat'][grains['id']]) }}
{% endif %}
{% if 'vlan' in pillar['neutron']['type_drivers'] %}
        ml2_type_vlan: 
          network_vlan_ranges: {{ salt['cluster_ops.get_vlan_ranges']() }}
{% endif %}
{% if 'gre' in pillar['neutron']['type_drivers'] %}
        ml2_type_gre: 
          tunnel_id_ranges: {{ pillar['neutron']['type_drivers']['gre']['tunnel_start'] }}:{{ pillar['neutron']['type_drivers']['gre']['tunnel_end'] }}
{% endif %}
{% if 'vxlan' in pillar['neutron']['type_drivers'] %}
        ml2_type_vxlan:
          vni_ranges: {{ pillar['neutron']['type_drivers']['gre']['tunnel_start'] }}:{{ pillar['neutron']['type_drivers']['gre']['tunnel_end'] }}
{% endif %}
        securitygroup:
          firewall_driver: neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver
          enable_security_group: True
    - require:
      - file: neutron-plugin-ml2
intergrationg_bridge:
  cmd:
    - run
    - name: "ovs-vsctl add-br {{ pillar['neutron'].get('intergration_bridge', 'br-int') }}"
{% for network_type in ['vlan', 'flat'] %}
{% for external_network in pillar['neutron']['type_drivers'].get(network_type, {}).get(grains['id'], {}) %}
{{ external_network }}-bridge-create:
  cmd:
    - run
    - name: "ovs-vsctl add-br {{ pillar['neutron']['type_drivers'][network_type][grains['id']][external_network]['bridge'] }}"
{{ external_network }}-interface-setup:
  cmd:
    - run
    - name: "ip link set {{ pillar['neutron']['type_drivers'][network_type][grains['id']][external_network]['interface'] }} up promisc on"
{{ external_network }}-interface-bridge:
  cmd:
    - run
    - name: "ovs-vsctl add-port {{ pillar['neutron']['type_drivers'][network_type][grains['id']][external_network]['bridge'] }} {{ pillar['neutron']['type_drivers'][network_type][grains['id']][external_network]['interface'] }}"
{% endfor %}
{% endfor %}
