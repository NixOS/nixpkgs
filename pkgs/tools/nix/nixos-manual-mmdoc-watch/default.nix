{ writeScriptBin, python3, entr } :
let
  np-build = writeScriptBin "np-build" ''
    nix build .#nixos-manual-mmdoc -L
  '';
in
writeScriptBin "nixpkgs-manual-mmdoc-watch" ''
  killbg() {
  for p in "''${pids[@]}" ; do
  kill "$p";
  done
  }
  trap killbg EXIT
  pids=()
  ${python3}/bin/python -m http.server --directory ./result &
  pids+=($!)
  trap exit SIGINT
  while true; do find nixos/doc pkgs/tools/nix/nixos-manual-mmdoc/ | ${entr}/bin/entr -cd ${np-build}/bin/np-build; done
''
