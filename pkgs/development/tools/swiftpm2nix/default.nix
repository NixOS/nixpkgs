{ lib, stdenv, callPackage, makeWrapper, jq, nix-prefetch-git }:

stdenv.mkDerivation {
  name = "swiftpm2nix";

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    install -vD ${./swiftpm2nix.sh} $out/bin/swiftpm2nix
    wrapProgram $out/bin/$name \
      --prefix PATH : ${lib.makeBinPath [ jq nix-prefetch-git ]} \
  '';

  preferLocalBuild = true;

  passthru = callPackage ./support.nix { };

  meta = {
    description = "Generate a Nix expression to fetch swiftpm dependencies";
    mainProgram = "swiftpm2nix";
    maintainers = with lib.maintainers; [ dtzWill trepetti dduan trundle stephank ];
    platforms = lib.platforms.all;
  };
}
