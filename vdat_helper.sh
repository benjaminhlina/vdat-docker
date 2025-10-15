# !/bin/bash

if [[ -e $1 && $1 =~ .*\.msi$ ]]; then
  echo "Extracting $1"

  # create a temporary directory and delete on exit
  VDAT_TEMP_DIR=$(mktemp -d)
  trap 'rm -rf "$VDAT_TEMP_DIR"' EXIT

  # copy the Fathom Connect installer to the temp directory
  cp $1 $VDAT_TEMP_DIR/fathom_connect.msi

  # Pull out vdat.exe from the Fathom Connect installer
  ## --rm -> remove container after run
  ## -v -> mount temporary directory to /VDAT in container
  ## vdat sh -c -> run the following commands in a shell within the container
  ## msiextract fathom_connect.msi > /dev/null -> extract the .msi file and 
  ##    suppress output
  ## mv Innovasea/Fathom\ Connect/vdat.exe /VDAT/vdat.exe -> move the extracted
  ##    vdat.exe file to the mounted directory

  docker run --rm \
    -v $VDAT_TEMP_DIR:/VDAT \
    ghcr.io/trackyverse/vdat sh -c \
      "msiextract fathom_connect.msi > /dev/null; \
      mv Innovasea/Fathom\ Connect/vdat.exe /VDAT/vdat.exe;
      rm -rf Innovasea"

  # copy vdat.exe to current directory
  cp $VDAT_TEMP_DIR/vdat.exe .

  # clean up temporary directory
  rm -rf $VDAT_TEMP_DIR

  echo "vdat.exe extracted to $PWD"
  
elif [[ -e $1 && $1 =~ .*vdat\.exe$ ]]; then
  # If the first argument is an existing vdat.exe file, run it with wine
  VDAT_FULL_PATH=$(readlink -f $1)
  docker run --rm \
    -v ${VDAT_FULL_PATH}:/VDAT/vdat.exe \
    ghcr.io/trackyverse/vdat sh -c "wine vdat.exe ${@:2}"

else
  echo -e "Command or file not found."
  exit 1
fi