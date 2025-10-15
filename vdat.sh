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

# If the first argument is not an MSI, run vdat.exe with Wine 
else
  if [[ ! -e "vdat.exe" ]]; then
    echo -e "vdat.exe not found in current directory."
    exit 1
  fi

  # Expand the full path of the vdat.exe file
  VDAT_FULL_PATH=$(readlink -f "vdat.exe")
  # This is the base command to run vdat.exe with wine in the container
  #   ${*:1} is grabbing all of the arguments
  #   So, it assumes: ./vdat.sh <vdat args>
  VDAT_CMD="wine vdat.exe ${*:1};"

  # This is overly strict and needs to be updated to allow for more options
  #   Right now it doesnt allow for multiple convert options
  # If vdat convert is being run and the 3rd argument is a .vdat or .vrl file, then
  #   build the docker command to mount the input file and output directory
  #   So, it assumes something like:
  #     ./vdat.sh convert --format=<format> <input.vdat>
  
  if [[ $1 == "convert" && $3 =~ .*\.v(dat|rl)$ ]]; then
    # If converting, we need to mount the input file to send it to the container
    #   AND mount an output directory to get the output files from the container
    THINGS_TO_MOUNT="-v ${PWD}/vdat_out:/VDAT/vdat_out -v $(readlink -f $3):/VDAT/$(basename $3)"

    if [[ $2 == "--format=csv.fathom" ]]; then
      # Move the output CSV file to the mounted output directory and set permissions
      VDAT_CMD+="mv ${3%.*}.csv /VDAT/vdat_out; chmod -R 666 /VDAT/vdat_out"
    else
      # Move the output folder to the mounted output directory and set permissions
      VDAT_CMD+="mv ${3%.*}.csv-fathom-split /VDAT/vdat_out; chmod -R 666 /VDAT/vdat_out"
    fi
  elif [[ $1 == "inspect" ]]; then
    # If inspecting, we need to mount the input file to send it to the container
    THINGS_TO_MOUNT="-v $(readlink -f $2):/VDAT/$(basename $2)"
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

fi