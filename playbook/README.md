# Ansible Playbook: Установка ClickHouse, Vector, Nginx и Lighthouse

Этот Ansible playbook автоматизирует установку и конфигурацию трех сервисов: **ClickHouse**, **Vector** и **Nginx с Lighthouse**. Каждый сервис устанавливается на разных хостах и управляется через обработчики Ansible.

## Обзор Playbook

### 1. Установка ClickHouse
Устанавливает и настраивает базу данных ClickHouse на хосте `clickhouse`.

- **Tasks**:
  - Загрузка пакетов ClickHouse.
  - Установка загруженных пакетов.
  - Создание базы данных `logs`.
  
- **Handlers**:
  - Запуск или перезапуск сервиса ClickHouse.

### 2. Установка Vector
Устанавливает инструмент наблюдения Vector на хосте `vector`.

- **Tasks**:
  - Загрузка пакета Vector.
  - Установка пакета и настройка сервиса.
  - Развертывание конфигурации Vector.
  
- **Handlers**:
  - Запуск сервиса Vector.

### 3. Установка Nginx и Lighthouse
Устанавливает Nginx и настраивает инструмент мониторинга Lighthouse на хосте `lighthouse`.

- **Tasks**:
  - Установка Nginx.
  - Настройка Nginx.
  - Настройка Lighthouse путем клонирования исходного кода и применения необходимых конфигураций.
  
- **Handlers**:
  - Запуск или перезапуск сервиса Nginx.

## Параметры Playbook

### Параметры ClickHouse
- **`clickhouse_version`**: Версия ClickHouse для установки.
- **`clickhouse_packages`**: Список пакетов ClickHouse для загрузки (`clickhouse-client`, `clickhouse-server` и т.д.).

### Параметры Vector
- **`vector_version`**: Версия Vector для установки.

### Параметры Lighthouse
- **`lighthouse_vcs`**: URL репозитория Git для исходного кода Lighthouse.
- **`lighthouse_location_dir`**: Директория, в которой будет установлен Lighthouse.

## Tags
Теги могут быть применены при запуске playbook для выполнения определенных частей:
- **`clickhouse`**: Установить ClickHouse и настроить его сервис.
- **`vector`**: Установить Vector и настроить его сервис.
- **`nginx`**: Установить и настроить Nginx.
- **`lighthouse`**: Настроить инструмент мониторинга Lighthouse.

### Пример использования

Чтобы запустить весь playbook:
```bash
ansible-playbook ansible-playbook -i inventory/prod.yml site.yml
```
To run only the ClickHouse part:
```
ansible-playbook playbook.yml ansible-playbook -i inventory/prod.yml site.yml --tags clickhouse
```
## Handlers
- ClickHouse: Start clickhouse service — Обеспечивает перезапуск сервиса ClickHouse после установки.
- Vector: Start vector service — Запускает сервис Vector после установки и настройки.
- Nginx:
    - start-nginx — Запускает или перезапускает сервис Nginx после изменений конфигурации.
    - restart-nginx — Перезагружает или перезапускает сервис Nginx после применения конфигурации Lighthouse.
Этот playbook упрощает развертывание этих сервисов с предопределенными параметрами и конфигурациями.