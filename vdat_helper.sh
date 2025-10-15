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
  ## ghcr.io/trackyverse/vdat sh -c -> run the following commands in a shell
  ##    within the container
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

# If the first argument is an existing vdat.exe file, run it with wine 
elif [[ -e $1 && $1 =~ .*vdat\.exe$ ]]; then
  # Expand the full path of the vdat.exe file
  VDAT_FULL_PATH=$(readlink -f $1)
  # This is the base command to run vdat.exe with wine in the container
  #   ${*:2} is grabbing all of arguments after the first one (vdat.exe)
  #   So, it assumes: ./vdat_helper.sh vdat.exe <other vdat args>
  VDAT_CMD="wine vdat.exe ${*:2};"

  # This is overly strict and needs to be updated to allow for more options
  #   Right now it doesnt allow for multiple convert options
  # If vdat convert is being run and the 4th argument is a .vdat or .vrl file, then
  #   build the docker command to mount the input file and output directory
  #   So, it assumes something like:
  #     ./vdat_helper.sh vdat.exe convert --format=<format> <input.vdat>
  
  if [[ $2 == "convert" && $4 =~ .*\.v(dat|rl)$ ]]; then
    # If converting, we need to mount the input file to send it to the container
    #   AND mount an output directory to get the output files from the container
    THINGS_TO_MOUNT="-v ${PWD}/vdat_out:/VDAT/vdat_out -v $(readlink -f $4):/VDAT/$(basename $4)"

    if [[ $3 == "--format=csv.fathom" ]]; then
      # Move the output CSV file to the mounted output directory and set permissions
      VDAT_CMD+="mv ${4%.*}.csv /VDAT/vdat_out; chmod -R 666 /VDAT/vdat_out"
    else
      # Move the output folder to the mounted output directory and set permissions
      VDAT_CMD+="mv ${4%.*}.csv-fathom-split /VDAT/vdat_out; chmod -R 666 /VDAT/vdat_out"
    fi
  elif [[ $2 == "inspect" ]]; then
    # If inspecting, we need to mount the input file to send it to the container
    THINGS_TO_MOUNT="-v $(readlink -f $3):/VDAT/$(basename $3)"
  fi
  
  # Run the vdat.exe command in the container with wine
  #   --rm -> remove container after run
  #   -v ${VDAT_FULL_PATH}:/VDAT/vdat.exe -> mount vdat.exe to the container
  #   $THINGS_TO_MOUNT -> mount any input/output files or directories if needed
  #   ghcr.io/trackyverse/vdat sh -c "$VDAT_CMD" -> run the vdat command in a shell
  #      within the container
  docker run --rm \
    -v ${VDAT_FULL_PATH}:/VDAT/vdat.exe \
    $THINGS_TO_MOUNT \
    ghcr.io/trackyverse/vdat sh -c "$VDAT_CMD"

else
  echo -e "Command or file not found."
  exit 1
fi