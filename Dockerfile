FROM registry.svc.ci.openshift.org/openshift/release:golang-1.10 AS builder
WORKDIR /go/src/github.com/jimmidyson/configmap-reload
COPY . .
RUN make out/configmap-reload

FROM  registry.svc.ci.openshift.org/openshift/origin-v4.0:base
LABEL io.k8s.display-name="OpenShift ConfigMap Reload" \
      io.k8s.description="This is a component reloads another process if a configured configmap volume is remounted." \
      io.openshift.tags="kubernetes" \
      maintainer="Frederic Branczyk <fbranczy@redhat.com>"

ARG FROM_DIRECTORY=/go/src/github.com/jimmidyson/configmap-reload
COPY --from=builder ${FROM_DIRECTORY}/out/configmap-reload  /usr/bin/configmap-reload

USER nobody

ENTRYPOINT ["/usr/bin/configmap-reload"]
