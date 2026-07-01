ARG BUILD_FROM
FROM ${BUILD_FROM}

# Wrap the upstream CatalogueCanvas image so Home Assistant can inject its
# options. The upstream base (python:3.14-alpine) has no bashio, so run.sh
# reads /data/options.json with the Python interpreter already in the image.
USER root
COPY run.sh /run.sh
RUN chmod +x /run.sh \
    && chown appuser:appuser /run.sh

USER appuser
WORKDIR /app/server
ENTRYPOINT []
CMD ["/run.sh"]
