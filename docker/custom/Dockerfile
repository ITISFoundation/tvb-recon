# Start from existing image and adapt the Dockerfile/entrypoint.sh accordingly
FROM thevirtualbrain/tvb-recon as base 
#
#  USAGE:
#     cd services/tvb-recon
#     docker build -f Dockerfile -t tvb-recon:prod --target production ../../
#     docker run tvb-recon:prod
#

LABEL maintainer=elisabettai

USER root
# simcore-user uid=8004(${SC_USER_NAME}) gid=8004(${SC_USER_NAME}) groups=8004(${SC_USER_NAME})
ENV SC_USER_ID 8004
ENV SC_USER_NAME scu
RUN adduser --uid ${SC_USER_ID} --disabled-password --gecos "" --shell /bin/bash --home /home/${SC_USER_NAME} ${SC_USER_NAME}

RUN apt-get update \
    && apt-get -y install --no-install-recommends \
    jq \
    git \
    zip \
    unzip \
    && rm --recursive --force /var/lib/apt/lists/*


# --------------------------Production stage -------------------
# Final cleanup up to reduce image size and startup setup
# Runs as ${SC_USER_NAME} (non-root user)
#
#  + /home/${SC_USER_NAME}     $HOME = WORKDIR
#    + tvb_recon [${SC_USER_NAME}:${SC_USER_NAME}]
#    + docker [${SC_USER_NAME}:${SC_USER_NAME}]
#    + service.cli [${SC_USER_NAME}:${SC_USER_NAME}]
#
FROM base as production

ENV SC_BUILD_TARGET production
ENV SC_BOOT_MODE production


ENV INPUT_FOLDER="/input" \
    OUTPUT_FOLDER="/output"

WORKDIR /home/${SC_USER_NAME}


# copy docker bootup scripts
COPY --chown=${SC_USER_NAME}:${SC_USER_NAME} docker/custom/*.sh docker/
# copy simcore service cli
COPY --chown=${SC_USER_NAME}:${SC_USER_NAME} service.cli/ service.cli/
# necessary to be able to call run directly without sh in front
ENV PATH="/home/${SC_USER_NAME}/service.cli:${PATH}"

ENTRYPOINT [ "/bin/bash", "docker/entrypoint.sh", "/bin/bash"]
CMD ["run"]
