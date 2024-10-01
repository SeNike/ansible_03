# Домашнее задание к занятию 3 «Использование Ansible»

![img](https://github.com/SeNike/Study_24/blob/main/ansible-02/ans3.1.png)
![img](https://github.com/SeNike/Study_24/blob/main/ansible-02/ans3.2.png)
![img](https://github.com/SeNike/Study_24/blob/main/ansible-02/ans3.3.png)

[README.md к Playbook](https://github.com/SeNike/ansible_03/blob/main/playbook/README.md)

Также выполнена автоматизация всего процесса от создания VM в YandexCloud до настройки серверов. 

_______________________________________________________________________________________________________________________________________________________________________________
# Скрипт автоматизации Terraform и Ansible

Этот Python-скрипт автоматизирует процесс выполнения Terraform для развертывания инфраструктуры, а затем запускает Ansible для настройки серверов. Скрипт управляет SSH-ключами и обновляет YAML файл инвентаря для Ansible на основе вывода Terraform.

## Предварительные требования

Перед запуском скрипта убедитесь, что у вас установлено следующее:

- Python 3.x
- Пакет `yaml` (можно установить через pip: `pip install pyyaml`)
- Terraform
- Ansible
- Настроенный доступ по SSH (с закрытым ключом, расположенным по пути `~/.ssh/id_rsa`)
- Для подключения Terraform к YandexCloud в каталоге terraform создан файл personal.auto.tfvars:
```personal.auto.tfvars
        token = "[yandex cloud token]"
        cloud_id = "[cloud id]"
        folder_id = "[folder.id]"
```
## Обзор скрипта

Скрипт состоит из следующих ключевых функций:

1. **run_ssh_agent**: Запускает SSH-агент.
2. **run_ssh_add**: Добавляет закрытый SSH-ключ в SSH-агент.
3. **run_terraform_apply**: Выполняет `terraform apply` для развертывания инфраструктуры.
4. **run_terraform_output**: Получает вывод Terraform в формате JSON.
5. **update_yaml**: Обновляет YAML файл инвентаря (`prod.yml`) на основе IP-адресов из вывода Terraform.
6. **run_ansible_playbook**: Выполняет Ansible плейбук с обновленным файлом инвентаря.

## Использование

Для использования этого скрипта:

1. Клонируйте или скачайте этот репозиторий.
2. Убедитесь, что ваши файлы конфигурации Terraform находятся в директории `./terraform`.
3. Поместите ваш Ansible плейбук в директорию `./playbook`.
4. Запустите скрипт с помощью Python:

   ```bash
   python run_project.py
   ```
### Обработка ошибок

Скрипт включает базовую обработку ошибок для вызовов подзадач. Если какая-либо команда завершится с ошибкой, на консоль будет выведено сообщение об ошибке.