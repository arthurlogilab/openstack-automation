#!jinja|json
{
    "nova-api": {
        "pkg": [
            "purged"
        ]
    },
    "nova-conductor": {
        "pkg": [
            "purged"
        ]
    },
    "nova-scheduler": {
        "pkg": [
            "purged"
        ]
    },
    "nova-cert": {
        "pkg": [
            "purged"
        ]
    },
    "nova-consoleauth": {
        "pkg": [
            "purged"
        ]
    },
    "nova-doc": {
        "pkg": [
            "purged"
        ]
    },
    "python-novaclient": {
        "pkg": [
            "purged"
        ]
    },
    "nova-ajax-console-proxy": {
        "pkg": [
            "purged"
        ]
    },
    "novnc": {
        "pkg": [
            "purged"
        ]
    },
    {% if grains['os'] == 'Ubuntu' %}
    "nova-novncproxy": {
    {% else %}
    "nova-consoleproxy": {
    {% endif %}
        "pkg": [
            "purged"
        ]
    },
    "nova_sqlite": {
        "file": [
            "absent",
            {
                "name": "/var/lib/nova/nova.sqlite"
            }
        ]
    }
}
