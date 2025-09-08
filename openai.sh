#!/bin/bash

# --- Конфигурация ---
HOSTS_FILE="/etc/hosts"

# Записи
ENTRIES_TO_ADD=(
    "204.12.192.222 chatgpt.com"
    "204.12.192.222 ab.chatgpt.com"
    "204.12.192.222 auth.openai.com"
    "204.12.192.222 auth0.openai.com"
    "204.12.192.222 platform.openai.com"
    "204.12.192.222 cdn.oaistatic.com"
    "204.12.192.222 files.oaiusercontent.com"
    "204.12.192.222 cdn.auth0.com"
    "204.12.192.222 tcr9i.chat.openai.com"
    "204.12.192.222 webrtc.chatgpt.com"
    "204.12.192.219 android.chat.openai.com"
    "204.12.192.222 api.openai.com"
    "204.12.192.221 operator.chatgpt.com"
    "204.12.192.222 sora.chatgpt.com"
    "204.12.192.222 sora.com"
    "204.12.192.222 videos.openai.com"
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
