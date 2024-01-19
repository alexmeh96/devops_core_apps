###Terraform-шаблоны ###

Команды:

`terraform init`  —  инициализация terraform. Создаёт в текущей дирректории папку `./terraform`

`terraform plan`   —  вывод плана построение инфраструктуры

`terraform apply -auto-approve`   —  запуск построение плана создания инфраструктуры, и исполнение его

`terraform apply -auto-approve -parallelism=1`  —   дополнительный флаг устанавливает параллельность выполнения терраформом работ

`terraform destroy -auto-approve`  —  запуск построение плана на удаление инфраструктуры и исполнения его
