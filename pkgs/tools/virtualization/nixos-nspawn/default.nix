{ stdenv, lib, python3 }:

stdenv.mkDerivation rec {
  name = "nixos-nspawn";
  src = lib.cleanSourceWith {
    src = ./.;
    filter = path: type:
      type == "regular" && ! (lib.hasSuffix "default.nix" path);
  };

  buildInputs = [ python3 python3.pkgs.wrapPython ];

  postPatch = ''
    sed -i -e '1,2d' ./nixos-nspawn.py
    sed -i -e '1s;^;#!${python3}/bin/python3;' ./nixos-nspawn.py

    substituteInPlace ./nixos-nspawn.py \
      --replace "@eval@" "${./eval-container.nix}"
  '';

  dontBuild = true;

  doCheck = true;
  checkInputs = [ python3.pkgs.flake8 ];
  checkPhase = ''
    flake8 ./nixos-nspawn.py --max-line-length 130 \
      --ignore E722,W503
  '';

  installPhase = ''
    buildPythonPath "${python3.pkgs.rich}"
    install -Dm0755 ./nixos-nspawn.py $out/bin/nixos-nspawn
    patchPythonScript $out/bin/nixos-nspawn
  '';

  shellHook = ''
    export NIXOS_NSPAWN_EVAL="${toString ./eval-container.nix}"
  '';

  meta.maintainers = with lib.maintainers; [ ma27 ];
}
