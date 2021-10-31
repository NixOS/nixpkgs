{
  stdenv
, lib
, callPackage
, makeWrapper
, nixos-option
, ncurses
, ...
}:
let
  inherit (lib) makeBinPath;
in
stdenv.mkDerivation {
  pname = "nix-option";
  version = "1.0";

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    # mkdir -p $out/bin
    makeWrapper "${./options}" "$out/bin/nix-option" \
      --prefix PATH : "${makeBinPath [ nixos-option ncurses ]}"
  '';
  dontUnpack = true;

  meta = with lib; {
    description = "nixos-option, but for the flake era";
    license = licenses.mit;
    maintainers = with maintainers; [ lucasew ];
    platforms = nixos-option.meta.platforms;
  };
}
