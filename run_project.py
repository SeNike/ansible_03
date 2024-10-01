import yaml
import subprocess
import json
import time
import os

secret_key = os.path.join(os.path.expanduser("~"), '.ssh', 'id_rsa')

def run_ssh_agent():
    # Запуск ssh-agent напрямую
    result = subprocess.run(['ssh-agent', '-s'], capture_output=True, text=True)
    print(result.stdout)

def run_ssh_add(secret_key):
    try:
        # Запуск команды `terraform apply`
        result = subprocess.run(['ssh-add', secret_key ])
    except subprocess.CalledProcessError as e:
        print(f"Error: {e}")        

def run_terraform_apply():
    try:
        # Запуск команды `terraform apply`
        result = subprocess.run(['terraform', 'apply', '-auto-approve' ], cwd="./terraform")
    except subprocess.CalledProcessError as e:
        print(f"Error: {e}")

def run_terraform_output():
    try:
        # Запуск команды `terraform output -json`
        result = subprocess.run(['terraform', 'output', '-json'], 
                                check=True, 
                                capture_output=True, 
                                text=True,
                                cwd="./terraform")
        # Парсинг JSON вывода
        output = json.loads(result.stdout)
        return output
    except subprocess.CalledProcessError as e:
        print(f"Error: {e}")
        return None

# Вызов функции и вывод результата
def update_yaml(terraform_output):
    # Предполагаем, что мы получили словарь с нужными IP
    nat_ip_addresses = terraform_output.get('nat_ip_addresses', {}).get('value', {})

    # Заготовка YAML файла
    data = {
        "clickhouse": {
            "hosts": {
                "clickhouse-01": {
                    "ansible_host": nat_ip_addresses.get("clickhouse"),
                    "ansible_user": "centos",
                    "ansible_ssh_common_args": "-o StrictHostKeyChecking=no"
                }
            }
        },
        "lighthouse": {
            "hosts": {
                "lighthouse-01": {
                    "ansible_host": nat_ip_addresses.get("lighthouse"),
                    "ansible_user": "centos",
                    "ansible_ssh_common_args": "-o StrictHostKeyChecking=no"
                }
            }
        },
        "vector": {
            "hosts": {
                "vector-01": {
                    "ansible_host": nat_ip_addresses.get("vector"),
                    "ansible_user": "centos",
                    "ansible_ssh_common_args": "-o StrictHostKeyChecking=no"
                }
            }
        }
    }

    # Запись в prod.yaml
    with open('./playbook/inventory/prod.yml', 'w') as file:
        yaml.dump(data, file, default_flow_style=False)

    print("prod.yaml успешно обновлен.")

def run_ansible_playbook():
    try:
        # Запуск команды `ansible-playbook`
        result = subprocess.run(['ansible-playbook', '-i', 'inventory/prod.yml', 'site.yml'], cwd="./playbook")
    except subprocess.CalledProcessError as e:
        print(f"Error: {e}")

run_ssh_agent()
run_ssh_add(secret_key)
#Запуск Terraform
run_terraform_apply()

# Запуск Terraform и обновление YAML
terraform_output = run_terraform_output()

if terraform_output:
    update_yaml(terraform_output)

time.sleep(30)
#Запуск Ansible    
run_ansible_playbook()    