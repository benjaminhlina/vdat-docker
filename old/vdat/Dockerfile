FROM alpine:3.21

COPY vdat.exe .

ENV WINEDEBUG=fixme-all,err-all

RUN apk add wine && wineboot

CMD [ "wine", "vdat.exe", "--help"]