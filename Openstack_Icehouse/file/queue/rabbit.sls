rabbitmq-server:
  pkg:
    - installed
  file.replace:
    - name: /etc/rabbitmq/rabbitmq-env.conf
    - pattern : 127.0.0.1
    - repl : 0.0.0.0
restart-rabbitmq-server:
  service.running:
    - name: rabbitmq-server
    - watch:
      - file: /etc/rabbitmq/rabbitmq-env.conf
