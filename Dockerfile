# e.g.
# docker build -t sysu-thesis:latest .
# docker run -i -v $(pwd):/sysu-thesis -u $(id -u ${USER}):$(id -g ${USER}) sysu-thesis:latest make pdf
FROM alpine:3.10

## init environment
RUN apk add --no-cache \
    texlive-full make git

# install font
RUN mkdir -p /usr/share/fonts/opentype
RUN git clone https://github.com/a20185/adobefonts
RUN chmod +x adobefonts/runner.sh
RUN adobefonts/runner.sh
RUN fc-cache -f -v

# add entrypoint
RUN echo $'#!/bin/sh\n\
cd /sysu-thesis\n\
cp sysuthesis.cls sysuthesis.cls.old\n\
sed -i "s/Times New Roman/Nimbus Roman No9 L/g" sysuthesis.cls\n\
$@\n\
mv sysuthesis.cls.old sysuthesis.cls\n' >>/entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "make", "pdf" ]
