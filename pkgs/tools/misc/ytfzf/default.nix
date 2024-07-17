{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  coreutils,
  curl,
  dmenu,
  fzf,
  gnused,
  jq,
  mpv,
  ueberzugpp,
  yt-dlp,
}:

stdenv.mkDerivation rec {
  pname = "ytfzf";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "pystardust";
    repo = "ytfzf";
    rev = "v${version}";
    hash = "sha256-rwCVOdu9UfTArISt8ITQtLU4Gj2EZd07bcFKvxXQ7Bc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installFlags = [
    "PREFIX="
    "DESTDIR=${placeholder "out"}"
    "doc"
    "addons"
  ];

  postInstall = ''
    wrapProgram "$out/bin/ytfzf" \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          curl
          dmenu
          fzf
          gnused
          jq
          mpv
          ueberzugpp
          yt-dlp
        ]
      } \
      --set YTFZF_SYSTEM_ADDON_DIR "$out/share/ytfzf/addons"
  '';

  meta = with lib; {
    description = "A posix script to find and watch youtube videos from the terminal";
    homepage = "https://github.com/pystardust/ytfzf";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ dotlambda ];
    mainProgram = "ytfzf";
  };
}
