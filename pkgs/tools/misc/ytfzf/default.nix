{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, chafa
, coreutils
, curl
, dmenu
, fzf
, gnused
, jq
, mpv
, ueberzug
, yt-dlp
}:

stdenv.mkDerivation rec {
  pname = "ytfzf";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "pystardust";
    repo = "ytfzf";
    rev = "v${version}";
    hash = "sha256-zfoICi1VChmrRHZ3dSHGTcXkVf/zirQTycFz98xj+QY=";
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
      --prefix PATH : ${lib.makeBinPath [
        chafa coreutils curl dmenu fzf gnused jq mpv ueberzug yt-dlp
      ]} \
      --set YTFZF_SYSTEM_ADDON_DIR "$out/share/ytfzf/addons"
  '';

  meta = with lib; {
    description = "A posix script to find and watch youtube videos from the terminal";
    homepage = "https://github.com/pystardust/ytfzf";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
