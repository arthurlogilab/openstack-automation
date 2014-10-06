{% if grains['os'] == 'Debian' %}
upgrade backport packages from gplhost:
  pkg.latest:
    - pkgs:
      - iproute
      - libusb-1.0-0
      - libyaml-0-2
      - python-crypto
      - python-psutil
    - require:
      - state: generic.sources
{% endif %}
