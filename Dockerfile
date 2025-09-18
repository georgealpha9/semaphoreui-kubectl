FROM alpine:3.19 as kubectl
ARG KUBECTL_VERSION=v1.33.4
RUN apk add --no-cache curl \
    && curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    && chmod +x kubectl

FROM semaphoreui/semaphore:latest
USER root
COPY --from=kubectl /kubectl /usr/local/bin/kubectl
USER 1001
ENTRYPOINT ["/sbin/tini", "--"]
CMD [ "/usr/local/bin/server-wrapper" ]
