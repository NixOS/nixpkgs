{ stdenv, lib, python3, nixosTests }:

stdenv.mkDerivation rec {
  name = "nixos-nspawn";
  src = lib.cleanSourceWith {
    src = ./.;
    filter = path: type:
      type == "regular" && ! (lib.hasSuffix "default.nix" path);
  };

  buildInputs = [ python3 python3.pkgs.wrapPython ];

  postPatch = ''
    # remove nix-shell shebang
    sed -i -e '1,3d' ./nixos-nspawn.py

    substituteInPlace ./nixos-nspawn.py \
      --replace "@eval@" "${./eval-container.nix}"
  '';

  dontBuild = true;

  passthru.tests = { inherit (nixosTests) containers-next-imperative; };

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
