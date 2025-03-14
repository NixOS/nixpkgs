{
  lib,
  fetchgit,
  nkf,
  callPackage,
}:

(callPackage ./generic.nix rec {
  gameName = "jnethack";
  version = "3.6.7-0.1";

  src = fetchgit {
    url = "http://scm.osdn.net/gitroot/jnethack/source.git";
    rev = "3b3a9c4e25df60f9bce2ad09ce368410b4360e85";
    hash = "sha256-yQZURMjz1FkYptwYgumV3gvab5l2WSJ7eLQcl+EdJGI=";
  };

  desktopItems = [
    {
      name = "JNetHack";
      exec = gameName;
      icon = gameName;
      desktopName = "JNetHack";
      comment = "JNetHack is a Japanese translation of NetHack";
      categories = [
        "Game"
        "ActionGame"
      ];
    }
  ];

  meta = {
    description = "Japanese translation of NetHack";
    homepage = "https://jnethack.osdn.jp";
    changelog = "https://osdn.net/projects/jnethack/scm/git/source/blobs/${src.rev}/ChangeLog.j";
    downloadPage = "https://osdn.net/projects/jnethack/latest/releases/release";
    license = "nethack";
    mainProgram = "jnethack";
    maintainers = with lib.maintainers; [ chayleaf ];
  };
}).overrideAttrs
  (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ nkf ];

    configurePhase = ''
      find . -type f | xargs -n1 nkf -e --overwrite
      ${old.configurePhase}
    '';
  })
