FROM alpine:3.19 as base
ARG KUBECTL_VERSION=v1.33.4
ARG SOPS_VERSION=v3.9.2
ARG FLUX_VERSION=v2.6.4
RUN apk add --no-cache curl \
    && curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && curl -LO "https://github.com/getsops/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux.amd64" \
    && mv sops-${SOPS_VERSION}.linux.amd64 sops \
    && chmod +x sops \
    && curl -LO "https://github.com/fluxcd/flux2/releases/download/${FLUX_VERSION}/flux_${FLUX_VERSION#v}_linux_amd64.tar.gz" \
    && tar -xzf flux_${FLUX_VERSION#v}_linux_amd64.tar.gz \
    && chmod +x flux

FROM semaphoreui/semaphore:latest
USER root
COPY --from=base /kubectl /usr/local/bin/kubectl
COPY --from=base /sops /usr/local/bin/sops
COPY --from=base /flux /usr/local/bin/flux
USER 1001
ENTRYPOINT ["/sbin/tini", "--"]
CMD [ "/usr/local/bin/server-wrapper" ]
