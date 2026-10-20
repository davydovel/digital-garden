#!/bin/bash
# Публикация Obsidian-заметок на GitHub Pages.
# Источник: Хранилище/Публичное → content → сборка → push.
set -euo pipefail

VAULT="/Users/evgenijdavydov/SecondBrain/Хранилище/Публичное"
GARDEN="/Users/evgenijdavydov/digital-garden"
export PATH="$HOME/homebrew/bin:$PATH"

if [ ! -d "$VAULT" ]; then
  echo "Нет папки $VAULT"
  exit 1
fi

echo "→ Копирую заметки"
rsync -a --delete \
  --exclude '.obsidian' \
  --exclude '.git' \
  --exclude '.trash' \
  --exclude '.stversions' \
  "$VAULT/" "$GARDEN/content/"

cd "$GARDEN"

echo "→ Собираю сайт"
npx quartz build

echo "→ Коммит и отправка"
git add -A
if git diff --cached --quiet; then
  echo "Изменений нет — ничего не отправляю"
  exit 0
fi
git commit -m "publish $(date '+%Y-%m-%d %H:%M')"
git push

echo "✓ Готово: https://davydovel.github.io/digital-garden/"
