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
  version = "2.1";

  src = fetchFromGitHub {
    owner = "pystardust";
    repo = "ytfzf";
    rev = "v${version}";
    hash = "sha256-NJLXXam7FmBWj9sM+S71e5o5e6OtVpw0m32kUo3Fbec=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installFlags = [ "PREFIX=${placeholder "out"}" "doc" ];

  postInstall = ''
    wrapProgram "$out/bin/ytfzf" --prefix PATH : ${lib.makeBinPath [
      chafa coreutils curl dmenu fzf gnused jq mpv ueberzug yt-dlp
    ]}
  '';

  meta = with lib; {
    description = "A posix script to find and watch youtube videos from the terminal";
    homepage = "https://github.com/pystardust/ytfzf";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
