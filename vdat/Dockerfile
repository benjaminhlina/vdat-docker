# set architecture 
# this right now does not follow docker protocal and results in a warning 
# see  https://docs.docker.com/build/building/multi-platform/
FROM --platform=linux/amd64 alpine:edge AS wine-base

# Does not cache the index locally, which is useful for keeping containers small.
# See https://stackoverflow.com/questions/49118579/alpine-dockerfile-advantages-of-no-cache-vs-rm-var-cache-apk 
# then install wine and wegt
RUN apk add --no-cache wget wine 

# use wget to install winetricks
# see https://github.com/scottyhardy/docker-wine/blob/6284e6ab06aef285263d1f77a5b1554afb1e83d9/Dockerfile#L38-L39
RUN wget -nv -O /usr/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    && chmod +x /usr/bin/winetricks

# set wine environment 
RUN wineboot --init || true
# copy
COPY vdat.exe .

# set WINEDLLPATH so Wine can find the correct DLLs
ENV WINEDLLPATH=/usr/lib/wine/x86_64-unix
ENV WINEPREFIX=/root/.wine

CMD [ "wine", "vdat.exe", "--help"]