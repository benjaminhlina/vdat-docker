FROM rocker/r2u

RUN Rscript -e "install.packages('remotes')"

RUN Rscript -e "remotes::install_github(c('ocean-tracking-network/glatos', 'mhpob/rvdat'))"
 
RUN apt install wine -y

RUN wineboot

COPY vdat.exe .

ENV WINEDEBUG=fixme-all,err-all

CMD [ "wine", "vdat.exe", "--help"]