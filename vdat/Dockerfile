# set architecture 
FROM --platform=linux/amd64 alpine:edge AS wine-base
# See https://stackoverflow.com/questions/49118579/alpine-dockerfile-advantages-of-no-cache-vs-rm-var-cache-apk 


# Does not cache the index locally, which is useful for keeping containers small.
# then install wine and wegt
RUN apk add --no-cache wine wget 

# wget winetricks to install wine 
# see https://github.com/scottyhardy/docker-wine/blob/6284e6ab06aef285263d1f77a5b1554afb1e83d9/Dockerfile#L38-L39
RUN wget -nv -O /usr/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    && chmod +x /usr/bin/winetricks

# Install wine environment
RUN wineboot --init || true
# copy
COPY vdat.exe .

# set WINEDLLPATH so Wine can find the correct DLLs
ENV WINEDLLPATH=/usr/lib/wine/x86_64-unix
ENV WINEPREFIX=/root/.wine

CMD [ "wine", "vdat.exe", "--help"]