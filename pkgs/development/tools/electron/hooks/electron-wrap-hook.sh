# shellcheck shell=bash

electronWrap() {
  if (( $# < 2 )); then
    echo "Usage: electronWrap pathToWrap wrapperPath [electronWrapperArgs]"
    echo ""
    echo "  Required:"
    echo "    pathToWrap: Path that Electron will execute"
    echo "    wrapperPath: The path that the wrapper will be placed"
    echo ""
    echo "  Optional:"
    echo "    electronWrapperArgs: Addtional arguments that will be appended to the wrapper"
    echo ""
    echo "  Example:"
    echo '    electronWrap "$out/share/app.asar" "$out/bin/myApp" --set COOL_ENV 1'
    exit 1
  fi

  # Required args
  local -r pathToWrap="$1"
  local -r wrapperPath="$2"

  # Pack the rest into the arg array
  local -ar electronWrapperArgs=("${@:3}")

  local -a electronWrapperArgsArray=(
    # Actually launch the Electron program
    "--add-flag" "$pathToWrap"
    # This is generally desired for `top` purposes, and node will
    # doesn't look adjacent to argv0, which is to say that it will
    # not look around the argv0 argument for other executables or files.
    "--inherit-argv0"
    # Tell Electron that it is being used in production reglardless of how it was built
    # electron-is-dev also supports this var.
    "--set-default" "ELECTRON_FORCE_IS_PACKAGED" "1"
  )

  # Concat user args to the flags array
  concatTo electronWrapperArgsArray electronWrapperArgs

  makeWrapper "@ELECTRON_PACKAGE@/bin/electron" \
    "$wrapperPath" \
    "${electronWrapperArgsArray[@]}"

  echo "wrapped $pathToWrap with Electron using:"

  local -ra tmp=("$wrapperPath" "${electronWrapperArgsArray[@]}")
  echoCmd "makeWrapper" "${tmp[@]}"
}

electronWrapHook() {
  echo "Running electronWrapHook..."

  local pathToWrap findResult cmdProgram

  # Check if the var is set, if so just use it.
  if [[ -v electronWrapPath ]]; then
    # Use the user input
    pathToWrap="$electronWrapPath"
  else
    # If electronWrapPath is not set...
    #
    # Look for files named "app.asar", output results as null-terminated string, and store each string to an array
    mapfile -t -d $'\0' findResult < <(find "${!outputBin:?}" -type f -a -name "app.asar" -print0)

    # Ensure only one is found
    if [[ ${#findResult[@]} -eq 0 ]]; then
      echo "electronWrapHook: did not find 'app.asar' in the bin output. Please supply the path to it with 'electronWrapPath'"
      exit 1
    elif [[ ${#findResult[@]} -gt 1 ]]; then
      echo "electronWrapHook: found multiple 'app.asar' files:"
      echo "${findResult[*]}"
      echo "Please supply the path to wrap with 'electronWrapPath'"
      exit 1
    else
      # If there is only exactly one result, use it.
      pathToWrap="${findResult[0]}"
    fi
  fi

  # Check if electronWrapperName is set, and use that unconditionally if so.
  if [[ -v electronWrapperName ]]; then
    # User input
    cmdProgram="$electronWrapperName"
  elif [[ -v NIX_MAIN_PROGRAM ]]; then
    # If not, check if meta.mainProgram has been set.
    cmdProgram="$NIX_MAIN_PROGRAM"
  else
    # If neither...
    echo "electronWrapHook: \$mainProgram is not set so we don't know how to set the binary name."
    echo "  To fix this set \`meta.mainProgram\` or \`electronWrapperName\`"
    exit 1
  fi

  local -a electronWrapperArgsArray=()
  concatTo electronWrapperArgsArray electronWrapperArgs

  mkdir -p "${!outputBin}/bin"
  electronWrap "$pathToWrap" "${!outputBin}/bin/${cmdProgram}" "${electronWrapperArgsArray[@]}"

  echo "electronWrapHook finished."
}

if [[ -z "${dontElectronWrap-}" ]]; then
  postInstall+=(electronWrapHook)
fi
