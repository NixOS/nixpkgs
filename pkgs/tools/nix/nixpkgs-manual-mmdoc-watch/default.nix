{ writeScriptBin, python3, inotify-tools } :

writeScriptBin "nixpkgs-manual-mmdoc-watch" ''
  killbg() {
    for p in "''${pids[@]}" ; do
      kill "$p";
    done
  }
  trap killbg EXIT

  nix-build . -A nixpkgs-manual-mmdoc

  pids=()
  ${python3}/bin/python -m http.server --directory ./result &
  pids+=($!)
  trap exit SIGINT

  while ${inotify-tools}/bin/inotifywait -e modify -e create doc pkgs/by-name/ni/nixpkgs-manual-mmdoc
  do
    nix-build . -A nixpkgs-manual-mmdoc
  done
''
