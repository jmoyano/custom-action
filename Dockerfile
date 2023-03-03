FROM archlinux

RUN pacman -Suy --noconfirm \
        bash \
        httpie \
        jq

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
COPY dummy_push.json /dummy_push.json

ENTRYPOINT ["entrypoint.sh"]
