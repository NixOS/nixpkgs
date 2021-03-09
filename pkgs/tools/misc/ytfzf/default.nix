{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, curl
, dmenu
, fzf
, jq
, mpv
, youtube-dl
}:

stdenv.mkDerivation rec {
  pname = "ytfzf";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "pystardust";
    repo = "ytfzf";
    rev = "v${version}";
    sha256 = "09znixn8mpkxipv2x3nrfxr2i8g7y58v25qssqf092j9lh85sf9h";
  };

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  dontBuild = true;

  # remove after next update
  preInstall = ''
    mkdir -p "$out/bin"
  '';

  postInstall = ''
    wrapProgram "$out/bin/ytfzf" --prefix PATH : ${lib.makeBinPath [
      curl dmenu fzf jq mpv youtube-dl
    ]}
  '';

  meta = with lib; {
    description = "A posix script to find and watch youtube videos from the terminal";
    homepage = "https://github.com/pystardust/ytfzf";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
