## Grafana

Grafana отображает данные собранные prometheus

Страница Grafana: http://localhost:3000

#### крэдлы по умолчанию

username: admin

password: admin

#### добавляем источник данных который будет prometheus

![img.png](.img/img.png)

![img_1.png](.img/img_1.png)

![img_2.png](.img/img_2.png)

![img_3.png](.img/img_3.png)

создаём панель мониторинга:

![img_4.png](.img/img_4.png)

![img_6.png](.img/img_6.png)

Уже сделанные кем-то панели: https://grafana.com/grafana/dashboards/

Буду использовать эту: https://grafana.com/grafana/dashboards/1860-node-exporter-full/

![img_5.png](.img/img_5.png)

![img_7.png](.img/img_7.png)

![img_9.png](.img/img_9.png)

![img_8.png](.img/img_8.png)

![img_10.png](.img/img_10.png)

после внесения изменеий в работе дашборда(отображать информацию за последние 5мин, обновляя её каждые 5с),
нужно нажать на сохранить:

![img_11.png](.img/img_11.png)

## Prometheus

Prometheus собирает данные из разных источников(экспортёров), делает http-запросы к экспортёрам.
Чтобы prometheus мог удачно их получить, экспортёры должны предоставлять эти метрики по http-запросу,
обычно по ***http://<exporter_hos>/metrics***

В конфинурационном файле config/prometheus.yaml указываем источники данных, откуда прометеус будет их брать к себе 

Страница Prometheus: http://localhost:9090

открыть список экспортёров:

![img.png](.img/img12.png)

## node exporter

node exporter - источник данных(экспортёр), который собирает метрики о системе(пямять, процессор и т.п.).
Потом эти метрики заберает к себе prometheus

https://github.com/prometheus/node_exporter

Страница node exporter: http://localhost:9100

## cadvisor

cadvisor - соберает метрики docker контейнеров
