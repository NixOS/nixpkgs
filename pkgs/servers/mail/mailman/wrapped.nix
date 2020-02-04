{ runCommand, lib, makeWrapper, python3
, archivers ? [ python3.pkgs.mailman-hyperkitty ]
}:

let
  inherit (python3.pkgs) makePythonPath mailman;
in

runCommand "${mailman.name}-wrapped" {
  inherit (mailman) meta;
  buildInputs = [ makeWrapper ];
  passthru = mailman.passthru // { unwrapped = mailman; };
} ''
  mkdir -p "$out/bin"
  cd "${mailman}/bin"
  for exe in *; do
    makeWrapper "${mailman}/bin/$exe" "$out/bin/$exe" \
        --set PYTHONPATH ${makePythonPath ([ mailman ] ++ archivers)}
  done
''
