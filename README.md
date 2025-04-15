# Innovasea's VDAT and trackyverse R packages on Linux

The Dockerfiles contained within this repository aim to provide access to Innovasea's VDAT executable, as well as the [`glatos`](https://github.com/ocean-tracking-network/glatos) and [`rvdat`](https://github.com/mhpob/rvdat) packages from the OTN-based trackyverse.

## Linux
1. [Install Docker](https://docs.docker.com/engine/install/)
2. Copy one of the Dockerfiles and place it into the same directory as `vdat.exe`
3. `cd` into the directory and run `docker build -t vdat .`