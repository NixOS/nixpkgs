{ pkgs, stdenv, lib, makeWrapper, yarn2nix, bundix, coreutils,
  diffutils, nix-prefetch-github, gnused, jq }:
stdenv.mkDerivation rec {
  name = "mastodon-update-script";
  installPhase = ''
    mkdir -p $out/bin
    cp ${./update.sh} $out/bin/update.sh
    patchShebangs $out/bin/update.sh
    wrapProgram $out/bin/update.sh --prefix PATH : ${lib.makeBinPath buildInputs}
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ yarn2nix bundix coreutils diffutils nix-prefetch-github gnused jq ];

  meta = {
    maintainers = with lib.maintainers; [ happy-river ];
    description = "Utility to generate Nix expressions for Mastodon's dependencies";
    platforms = lib.platforms.unix;
  };
}
