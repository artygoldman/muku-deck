FROM caddy:2-alpine
COPY site/ /srv/
CMD ["sh","-c","caddy file-server --root /srv --listen :${PORT:-80}"]
