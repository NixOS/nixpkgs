{
  mkTmuxPlugin,
  replaceVars,
  fetchFromGitHub,
  crystal,
}:
let
  fingers = crystal.buildCrystalPackage rec {
    format = "shards";
    version = "2.4.1";
    pname = "fingers";
    src = fetchFromGitHub {
      owner = "Morantron";
      repo = "tmux-fingers";
      rev = "${version}";
      sha256 = "sha256-djSf5zsxrUbkVhWzz6t8Usvk2HtBbQNCMeMc+5V3x/M=";
    };

    shardsFile = ./shards.nix;
    crystalBinaries.tmux-fingers.src = "src/fingers.cr";

    postInstall = ''
      shopt -s dotglob extglob
      rm -rv !("tmux-fingers.tmux"|"bin")
      shopt -u dotglob extglob
    '';

    # TODO: Needs starting a TMUX session to run tests
    # Unhandled exception: Missing ENV key: "TMUX" (KeyError)
    doCheck = false;
    doInstallCheck = false;
  };
in
mkTmuxPlugin {
  inherit (fingers) version src meta;

  pluginName = fingers.src.repo;
  rtpFilePath = "tmux-fingers.tmux";

  patches = [
    (replaceVars ./fix.patch {
      tmuxFingersDir = "${fingers}/bin";
    })
  ];
}
