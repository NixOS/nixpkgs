{ pkgs
, runCommand
, lib
, makeWrapper
, yarn2nix
, bundix
, coreutils
, diffutils
, nix-prefetch-git
, gnused
, jq
}:
let
  binPath = lib.makeBinPath [ yarn2nix bundix coreutils diffutils nix-prefetch-git gnused jq ];
in
runCommand "mastodon-update-script"
{
  nativeBuildInputs = [ makeWrapper ];

  meta = {
    maintainers = with lib.maintainers; [ happy-river ];
    description = "Utility to generate Nix expressions for Mastodon's dependencies";
    platforms = lib.platforms.unix;
  };
} ''
  mkdir -p $out/bin
  cp ${./update.sh} $out/bin/update.sh
  patchShebangs $out/bin/update.sh
  wrapProgram $out/bin/update.sh --prefix PATH : ${binPath}
''
