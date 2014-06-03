# -*- coding: utf-8 -*-
'''
Module for handling Cluster management in salt
'''


def __virtual__():
    '''
    No deps. Load the module
    '''
    return 'cluster_ops'


def list_sls(machine=None):
    '''
    Get list of sls to apply from pillar data
    '''
    host_sls = []
    for role in list_roles(machine):
        for sls in __pillar__.get('install', {}).get(role, []):
            if sls not in host_sls:
                host_sls.append(sls)
    return host_sls


def list_roles(machine=None):
    '''
    Get list of roles played by host
    '''
    if not machine:
        machine = __grains__['id']
    return [cluster_entity for cluster_entity in
            __pillar__.get('cluster_entities', [])
            if machine in __pillar__.get(cluster_entity, [])]


def list_hosts():
    '''
    Get list of hosts available in cluster
    '''
    host_list = []
    for cluster_entity in __pillar__.get('cluster_entities', []):
        for host in __pillar__.get(cluster_entity, []):
            if host not in host_list:
                host_list.append(host)
    return host_list


def get_candidate(name=None):
    for host in list_hosts():
        if name in list_sls(machine=host):
            return host


def get_vlan_ranges():
    physical_iter = []
    for physical_network in __pillar__['neutron']['type_drivers']['vlan'].get(__grains__['id'], {}):
		network_iter = [physical_network]
		for vlan in __pillar__['neutron']['type_drivers']['vlan'][__grains__['id']][physical_network].get('vlan_range', []):
			network_iter.append(vlan)
		physical_iter.append(':'.join(network_iter))
    return ','.join(physical_iter)


def get_bridge_mappings():
    bridge_iter = []
    for physical_network in __pillar__['neutron']['type_drivers'].get('flat', {}).get(__grains__['id'], {}):
        network_iter = [physical_network, __pillar__['neutron']['type_drivers']['flat'][__grains__['id']][physical_network]['bridge']]
        bridge_iter.append(':'.join(network_iter))
    for physical_network in __pillar__['neutron']['type_drivers'].get('vlan', {}).get(__grains__['id'], {}):
        network_iter = [physical_network, __pillar__['neutron']['type_drivers']['vlan'][__grains__['id']][physical_network]['bridge']]
        bridge_iter.append(':'.join(network_iter))
    return ','.join(bridge_iter)
