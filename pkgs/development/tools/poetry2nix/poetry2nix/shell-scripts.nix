{ lib
, scripts
, python
}:
let
  mkScript = bin: entrypoint:
    let
      elem = builtins.elemAt (builtins.split ":" entrypoint);
      module = elem 0;
      fn = elem 2;
    in
    ''
      cat << EOF >> $out/bin/${bin}
      #!${python.interpreter}
      import sys
      import re

      # Insert "" to add CWD to import path
      sys.path.insert(0, "")

      from ${module} import ${fn}

      if __name__ == '__main__':
          sys.argv[0] = re.sub(r'(-script\.pyw|\.exe)?$', "", sys.argv[0])
          sys.exit(${fn}())
      EOF
      chmod +x $out/bin/${bin}
    '';
in
python.pkgs.buildPythonPackage {
  name = "poetry2nix-env-scripts";
  dontUnpack = true;
  dontUseSetuptoolsBuild = true;
  dontConfigure = true;
  dontUseSetuptoolsCheck = true;

  format = "poetry2nix";

  installPhase = ''
    mkdir -p $out/bin
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList mkScript scripts)}
  '';
}
