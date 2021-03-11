ARG mugs_version=latest
FROM mugs-ui-cli:$mugs_version
ARG mugs_version

LABEL org.opencontainers.image.source=https://github.com/Raku-MUGS/MUGS

USER root:root

COPY . /home/raku

RUN zef install . --/test

USER raku:raku

ENTRYPOINT []
