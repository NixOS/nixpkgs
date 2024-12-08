{ runtimeShell
, symlinkJoin
, writeShellScriptBin
, npush
}:

let
  runScript = writeShellScriptBin "run-npush" ''
    set -euo pipefail
    CWD=$(pwd)

    if [ -d "./levels" ]; then
      echo "Directory ./levels found; skipping levelset copy"
    else
      echo "Directory ./levels not found; copying the official levelset to the current directory"
      mkdir -p ./levels
      cp ${npush}/share/npush/levels/* levels/
      chmod 644 levels/*
    fi
    echo "Now calling npush"
    exec "${npush}/bin/npush"
  '';
in
symlinkJoin {
  name = "run-npush-${npush.version}";

  paths = [
    npush
    runScript
  ];
}
