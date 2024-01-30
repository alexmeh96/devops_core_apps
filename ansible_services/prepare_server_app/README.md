добавление роли для установки docker и pip
```shell
ansible-galaxy role install geerlingguy.docker geerlingguy.pip
```
запуск плэйбука
```shell
ansible-playbook -i hosts.ini --user=user1 install_docker.yaml
```
