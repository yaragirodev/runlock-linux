#!/bin/bash

# --- Конфигурация ---
HOSTS_FILE="/etc/hosts"

# Записи
ENTRIES_TO_ADD=(
    "204.12.192.222 gemini.google.com"
    "204.12.192.222 aistudio.google.com"
    "204.12.192.222 generativelanguage.googleapis.com"
    "204.12.192.222 aitestkitchen.withgoogle.com"
    "204.12.192.219 aisandbox-pa.googleapis.com"
    "204.12.192.222 webchannel-alkalimakersuite-pa.clients6.google.com"
    "204.12.192.221 alkalimakersuite-pa.clients6.google.com"
    "204.12.192.221 assistant-s3-pa.googleapis.com"
    "204.12.192.222 proactivebackend-pa.googleapis.com"
    "204.12.192.222 o.pki.goog"
    "204.12.192.222 labs.google"
    "204.12.192.222 notebooklm.google"
    "204.12.192.222 notebooklm.google.com"
    "204.12.192.222 jules.google.com"
    "204.12.192.222 stitch.withgoogle.com"
)

# --- sudo? ---
if [ "$EUID" -ne 0 ]; then
  echo "Ошибка: Пожалуйста, запустите этот скрипт с правами суперпользователя (sudo)."
  exit 1
fi

# --- Создание резервной копии ---
BACKUP_FILE="${HOSTS_FILE}.backup_$(date +%Y-%m-%d_%H-%M-%S)"
echo "-> Создание резервной копии файла hosts в: ${BACKUP_FILE}"
cp "$HOSTS_FILE" "$BACKUP_FILE"
if [ $? -ne 0 ]; then
    echo "Ошибка: Не удалось создать резервную копию. Прерывание операции."
    exit 1
fi

# --- Добавление записей ---
echo "-> Добавление новых записей в ${HOSTS_FILE}..."

# Добавляем заголовок для новых записей для наглядности
echo "" >> "$HOSTS_FILE"
echo "# --- Записи для OpenAI/ChatGPT, добавленные скриптом $(date) --- #" >> "$HOSTS_FILE"

for entry in "${ENTRIES_TO_ADD[@]}"; do
    # Извлекаем домен для проверки
    domain=$(echo "$entry" | awk '{print $2}')
    
    # Проверяем, существует ли уже правило для этого домена
    if grep -qP "\s${domain}\s*$" "$HOSTS_FILE"; then
        echo "Предупреждение: Правило для домена \"${domain}\" уже существует. Пропускаем."
    else
        # Добавляем запись в файл
        echo "${entry}" >> "$HOSTS_FILE"
        echo "   Добавлено: \"${entry}\""
    fi
done

echo "# --- Конец записей, добавленных скриптом --- #" >> "$HOSTS_FILE"
echo "" >> "$HOSTS_FILE"

echo "-> Готово! Файл hosts успешно обновлен."

exit 0
