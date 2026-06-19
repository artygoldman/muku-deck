#!/usr/bin/env bash
# MUKU — генерация визуала через Higgsfield и раскладка в site/assets/.
# Запускать ПОСЛЕ пополнения кредитов Higgsfield (нужно ~5-7 кредитов на набор).
#   higgsfield account status   # проверить баланс
#   bash generate_assets.sh
# Затем в index.html в нужном .plate / .cell.shot заменить SVG-заглушку на:
#   <img src="assets/hero.jpg" alt="MUKU" style="width:100%;height:100%;object-fit:cover">
set -u
cd "$(dirname "$0")"
mkdir -p assets

gen () {
  local name="$1"; local ar="$2"; local prompt="$3"
  echo "==> $name ($ar)"
  local json; json="$(higgsfield generate create gpt_image_2 --prompt "$prompt" \
      --aspect_ratio "$ar" --resolution 2k --wait --wait-timeout 8m --json 2>/dev/null)"
  local url; url="$(printf '%s' "$json" | python3 -c "import sys,re;m=re.findall(r'https?://[^\"\\\\ ]+\.(?:jpg|jpeg|png|webp)',sys.stdin.read());print(m[0] if m else '')")"
  if [ -n "$url" ]; then curl -fsSL "$url" -o "assets/$name.jpg" && echo "    saved assets/$name.jpg"; \
  else echo "    !! не удалось получить URL — проверь баланс/вывод: higgsfield generate list"; fi
}

gen hero          16:9 "Premium editorial product photography of a minimalist solid bamboo bathtub caddy tray laid across a modern freestanding tub. On the tray: an open book, a matte ceramic tea cup, a small lit candle, a folded linen cloth. Soft diffused north-window light, calm Japanese onsen atmosphere, gentle steam over still clear water, cool desaturated bone/grey/sage palette, generous negative space, medium format, shallow depth of field, photorealistic, no text."
gen product       3:4  "Clean studio product photo of an extendable solid bamboo bath tray, three-quarter angle on soft cool-grey seamless background, fine water droplets beading on the surface, even neutral light, premium e-commerce, photorealistic, no text."
gen listing-main  1:1  "Amazon main image: solid bamboo bath tray centered on pure white #ffffff background, product fills about 85 percent of the frame, even soft light, no props, no text, crisp e-commerce hero, photorealistic."
gen packaging     16:9 "Premium minimal product packaging: a cool light-grey rigid box for a bamboo bath tray with a subtle embossed Japanese logo, clean studio light on soft grey surface, photorealistic, no extra text."

# Дополнительно для галереи (опционально):
gen lifestyle     3:4  "Lifestyle photo: a woman's hand reaching for a ceramic cup on a bamboo bath tray across a warm bath, candle glow, steam, cozy evening ritual, cool film tones, photorealistic, no text."
gen materials     1:1  "Extreme macro of fine bamboo grain with a single water droplet, showing matte protective finish, cool soft light, premium material close-up, photorealistic, no text."

echo "Готово. Файлы в site/assets/. Дальше заменить заглушки на <img> в index.html."
