FROM rhub/r-minimal

# System libraries for glatos, rvdat, and dependencies:
#   av: ffmpeg-dev
#   igraph: glpk-dev, libxml2-dev
#   KernSmooth: gfortran
#   Rcppcore/Rcpp linux-headers
#   s2: openssl-dev
#   sf, terra: gdal-dev, gdal-tools, geos-dev, proj-dev, sqlite-dev
#   units: udunits-dev
ARG temp_system_packages="ffmpeg-dev glpk-dev libxml2-dev linux-headers gfortran\
  openssl-dev gdal-dev gdal-tools geos-dev proj-dev sqlite-dev udunits-dev"

ARG keep_system_packages="ffmpeg glpk libssl3 libxml2 proj gdal geos expat udunits"

RUN installr -d \
    -t "$temp_system_packages" \
    -a "$keep_system_packages" \
    Rcppcore/Rcpp ocean-tracking-network/glatos mhpob/rvdat

RUN apk add wine-dev && wineboot

COPY vdat.exe .

ENV WINEDEBUG=fixme-all,err-all

CMD [ "wine", "vdat.exe", "--help"]