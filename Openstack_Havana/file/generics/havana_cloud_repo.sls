#!jinja|json
{
	{% for repo in pillar['cloud_repos'] %}
		"{{ repo['reponame'] }}": {
			"pkgrepo": [
				"managed",
				{
					"name": "{{ repo['name'] }}",
					"file": "{{ repo['file'] }}"
    {% if grains["os"] == "Debian" %}
					,"key_url": "{{ repo['key_url'] }}"
    {% endif %}
                          }
    {% if grains["os"] == "Ubuntu" %}
                              , {
                                       "require": [
                                               {
                                                       "pkg": "cloud-repo-keyring"
                                               }
                                       ]
                               }
    {% endif %}
			]
		},
      {% endfor %}
    {% if grains["os"] == "Ubuntu" %}
		"cloud-repo-keyring": {
			"pkg": [
				"installed",
				{
					"name": "ubuntu-cloud-keyring"
				}
			]
		},
    {% endif %}
    {% if grains["os"] == "Debian" %}
              "cloud-repo-havana-pinning": {
                    "file": [
                          "managed",
                              { 
                                  "name" : "/etc/apt/preferences.d/havana",
                                  "source": "salt://generics/havana"
                              }
                          ]
              },
    {% endif %}
    "cloud-keyring-refresh-repo": {
		"module": [
			"run",
			{
				"name": "saltutil.sync_all"
			}
		]
    }
}
