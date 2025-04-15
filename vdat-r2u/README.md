# vdat-r2u

# WORK IN PROGRESS!!

Docker image based on [rocker/r2u](https://github.com/rocker-org/r2u).

Current image is 3.73GB, and half of that (1.5GB) is due to Wine. On the R side, r2u uses precompiled binaries, so R and related packages take ~5 min to build. Wine takes another minute or so to install.

This image contains full versions of glatos and rvdat packages, though neither of them work at the moment -- they need to be refactored to take on the need to call VDAT via "`wine vdat.exe`" rather than just "`vdat.exe`"

Note that you will need to have the VDAT executable "`vdat.exe`" in your working directory when building the image.

Build the image:
```
docker build -t vdat-r2u .
```

Run the container:
```
docker run --rm vdat-r2u
```

To send arguments to vdat, you'll have to run things through Wine:
```
docker run --rm vdat-r2u wine vdat.exe -v
```
