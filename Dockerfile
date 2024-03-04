ARG mugs_version=latest
FROM mugs-ui-websimple:$mugs_version
ARG mugs_version

LABEL org.opencontainers.image.source=https://github.com/Raku-MUGS/MUGS

USER raku:raku

WORKDIR /home/raku/MUGS/MUGS
COPY . .

RUN zef install --deps-only . \
 && zef install . --/test \
 && rm -rf /home/raku/.zef $(find /tmp/.zef -maxdepth 1 -user raku)

CMD []
