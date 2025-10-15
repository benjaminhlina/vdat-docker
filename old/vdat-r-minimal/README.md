# vdat-r-minimal

# WORK IN PROGRESS!!

Docker image based on [r-hub/r-minimal](https://github.com/r-hub/r-minimal).

Current image is not too lightweight (2.05GB), but most of that (1.5BGB!) is due to Wine. On the R side, everything needs to be compiled so it can take a long time (upwards of 15 minutes) to build! This is suggested for those who are willing to wait a little longer for something a little lighter.

This image contains full versions of glatos and rvdat packages, though neither of them work at the moment -- they need to be refactored to take on the need to call VDAT via "`wine vdat.exe`" rather than just "`vdat.exe`"

Note that you will need to have the VDAT executable "`vdat.exe`" in your working directory when building the image.

Build the image:
```
docker build -t vdat-lite .
```

Run the container:
```
docker run --rm vdat-lite
```

To send arguments to vdat, you'll have to run things through Wine:
```
docker run --rm vdat-lite wine vdat.exe -v
```
