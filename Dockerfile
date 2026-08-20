FROM registry.access.redhat.com/ubi9/php-82

USER 0
RUN dnf install -y php-pgsql && dnf clean all
RUN rm -rf /opt/app-root/src/*
COPY . /opt/app-root/src/
RUN chgrp -R 0 /opt/app-root/src && chmod -R g=u /opt/app-root/src
USER 1001

EXPOSE 8080

CMD ["/usr/libexec/s2i/run"]
