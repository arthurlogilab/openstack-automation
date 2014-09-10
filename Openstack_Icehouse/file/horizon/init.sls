apache2: 
  pkg: 
    - installed
    - require: 
      - pkg: memcached
  service: 
    - running
    - watch: 
      - file: enable-dashboard-ssl
      - pkg: libapache2-mod-wsgi
enable-redirect:
  cmd.run:
    - name : 'a2enmod rewrite'
    - unless : 'ls /etc/apache2/mods-enabled/rewrite.load'
enable-ssl:
  cmd.run:
    - name : 'a2enmod ssl'
    - unless : 'ls /etc/apache2/mods-enabled/ssl.load'
disable-default:
  file.absent:
    - name : /etc/apache2/sites-enabled/000-default
    - require: 
      - pkg: openstack-dashboard
enable-dashboard-ssl-redirect:
  file.symlink:
    - force: true
    - name: /etc/apache2/sites-enabled/openstack-dashboard-ssl-redirect.conf
    - target: /etc/apache2/sites-available/openstack-dashboard-ssl-redirect.conf
    - require: 
      - pkg: openstack-dashboard
enable-dashboard-ssl: 
  file.symlink:
    - force: true
    - name: /etc/apache2/sites-enabled/openstack-dashboard-ssl.conf
    - target: /etc/apache2/sites-available/openstack-dashboard-ssl.conf
    - require: 
      - pkg: openstack-dashboard
libapache2-mod-wsgi: 
  pkg: 
    - installed
    - require: 
      - pkg: apache2
memcached: 
  pkg: 
    - installed
  service: 
    - running
    - watch: 
      - pkg: memcached
openstack-dashboard: 
  pkg: 
    - installed
    - require: 
      - pkg: apache2
