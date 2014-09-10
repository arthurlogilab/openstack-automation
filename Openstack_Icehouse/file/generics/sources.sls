{% if grains['os'] == 'Debian' %}
gpl-host-repository:
  pkgrepo.managed:
    - file: /etc/apt/sources.list.d/gplhost.list
    - human_name: GPLHost IceHouse packages
    - name: deb http://archive.gplhost.com/debian icehouse main
    - gpgcheck: 1
  file.managed:
    - name:  /etc/apt/trusted.gpg.d/gplhost.gpg
    - source: salt://apt/keys/gplhost.gpg
gpl-host-backports-repository:
  pkgrepo.managed:
    - file: /etc/apt/sources.list.d/gplhost.list
    - human_name: GPLHost IceHouse backports packages
    - name: deb http://archive.gplhost.com/debian icehouse-backports main
    - gpgcheck: 1
gpl-host-pinning:
  file.managed:
    - name : /etc/apt/preferences.d/gplhost
    - source : salt://generics/gplhost
python-argparse:
  pkg.installed
upgrade backport packages from gplhost:
  pkg.latest:
    - pkgs:
      - iproute
      - libusb-1.0-0
      - libyaml-0-2
      - python-crypto
      - python-psutil
{% endif %}
