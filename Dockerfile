FROM alpine:latest
MAINTAINER MarcoXu<woodbird456@gmail.com>
ADD jq /usr/bin/
ADD pod2dns.sh /usr/bin
ADD schedulePod2dns.sh /usr/bin
RUN apk update && apk add curl && apk add bash
ENTRYPOINT schedulePod2dns.sh
