{ pkgs ? import <nixpkgs> { }
, lib ? pkgs.lib
}:
let
  inherit (pkgs) python3;
  pname = "poetry2nix-cli";
in
pkgs.stdenv.mkDerivation {
  inherit pname;
  version = "0";

  buildInputs = [
    (python3.withPackages (ps: [ ps.toml ]))
  ];

  nativeBuildInputs = [
    pkgs.makeWrapper
  ];

  src = ./bin;

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    # this is the ./bin/poetry2nix
    patchShebangs poetry2nix
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    # need to remap this to be consistent with `pkgs.lib.getBin` "standard"
    mv poetry2nix $out/bin/${pname}

    wrapProgram $out/bin/${pname} --prefix PATH ":" ${lib.makeBinPath [
      pkgs.nix-prefetch-git
    ]}

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/nix-community/poetry2nix";
    description = "CLI to supplement sha256 hashes for git dependencies";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.adisbladis ];
  };

}
