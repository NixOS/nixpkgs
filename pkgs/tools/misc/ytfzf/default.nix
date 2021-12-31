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
  version = "2.0";

  src = fetchFromGitHub {
    owner = "pystardust";
    repo = "ytfzf";
    rev = "v${version}";
    sha256 = "sha256-JuLfFC3oz2FvCaD+XPuL1N8tGKmv4atyZIBeDKWYgT8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [ "PREFIX=${placeholder "out"}/bin" ];

  dontBuild = true;

  postInstall = ''
    wrapProgram "$out/bin/ytfzf" --prefix PATH : ${lib.makeBinPath [
      chafa coreutils curl dmenu fzf gnused jq mpv ueberzug yt-dlp
    ]}

    gzip -c docs/man/ytfzf.1 > docs/man/ytfzf.1.gz
    gzip -c docs/man/ytfzf.5 > docs/man/ytfzf.5.gz
    install -Dt "$out/share/man/man1" docs/man/ytfzf.1.gz
    install -Dt "$out/share/man/man5" docs/man/ytfzf.5.gz
  '';

  meta = with lib; {
    description = "A posix script to find and watch youtube videos from the terminal";
    homepage = "https://github.com/pystardust/ytfzf";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
