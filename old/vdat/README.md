# vdat: A WORK IN PROGRESS!

An Alpine Linux-based container with Wine. Uses a local version of `vdat.exe`. Current size is 1.47 GB.

Build the image:
```
docker build -t vdat .
```

Run the container:
```
$ docker run --rm vdat

Usage: Z:\vdat.exe [OPTIONS] [SUBCOMMAND]

Options:
  -h,--help                   Show help and summary of commands, or detailed
                              help for selected command (and exit)
  --help-all                  Show help for all commands (and exit)
  -v,--version                Print application version (and exit)
  --app-id                    Print application identity (and exit)


Subcommands:
  convert                     Convert file to the given file format
  inspect                     Describe the content of an existing file
  template                    Generate template for a given file format
```

To send arguments to vdat, you'll have to run things through Wine:
```
$ docker run --rm vdat wine vdat.exe -v

vdat-11.0.1-20240830-d01c0d-release
```
