# Домашнее задание к занятию "`Обзор систем IT-мониторинга`" - `Горбунов Владимир`



### Задание 1

`Создание ВМ, дашборда, подключение мониторинга Unified Agent с помощью терраформа:`\
https://github.com/Night-N/8-monitoring/blob/master/main.tf

`Unified agent устанавливается передачей метаданных при создании машины:`\
```
#cloud-config\nruncmd:\n  - 'wget -O - https://monitoring.api.cloud.yandex.net/monitoring/v2/unifiedAgent/config/install.sh | bash'
```
`Дашборд:`\
![Название скриншота](https://github.com/Night-N/8-monitoring/blob/master/mon-dashboard.jpg)



---

### Задание 2

`Машина нагружена с помощью утилиты stress:`\

![Название скриншота](https://github.com/Night-N/8-monitoring/blob/master/mon-stress.jpg)


`Отображение в панели:`\

![Название скриншота](https://github.com/Night-N/8-monitoring/blob/master/mon-alert2.jpg)



`Уведомление на почте:`\


![Название скриншота](https://github.com/Night-N/8-monitoring/blob/master/mon-alert.jpg)

