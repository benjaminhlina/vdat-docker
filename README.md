# Innovasea's VDAT and trackyverse R packages on Linux

The Dockerfiles contained within this repository aim to provide access to Innovasea's VDAT executable, as well as the [`glatos`](https://github.com/ocean-tracking-network/glatos) and [`rvdat`](https://github.com/mhpob/rvdat) packages from the OTN-based trackyverse. You'll need to download Fathom Connect from [Innovasea's Download page](https://support.fishtracking.innovasea.com/s/downloads) and extract the vdat executable.

- [vdat](https://github.com/trackyverse/vdat-docker/tree/main/vdat) just runs vdat.exe in Wine.
- [vdat-r2u](https://github.com/trackyverse/vdat-docker/tree/main/vdat-r2u) also contains a full version of R, as well as the `glatos` and `rvdat` packages.
- [vdat-r-minimal](https://github.com/trackyverse/vdat-docker/tree/main/vdat-r-minimal) contains a minimal version of R, along with `glatos` and `rvdat`.

## Linux
1. [Install Docker](https://docs.docker.com/engine/install/)
2. "Install" Fathom Connect to unpack `vdat.exe` using either a separate Windows machine or wine (`wine msiexec -qb Fathom_Installer.msi`).
3. Copy one of the Dockerfiles and place it into the same directory as `vdat.exe`
4. `cd` into the directory and run `docker build -t vdat .`
