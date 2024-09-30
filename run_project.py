import yaml
import subprocess
import json

# Функция для запуска команды и возврата результата
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

# Запуск Terraform и обновление YAML
terraform_output = run_terraform_output()

if terraform_output:
    update_yaml(terraform_output)