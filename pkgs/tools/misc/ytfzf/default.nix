{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, coreutils
, curl
, dmenu
, fzf
, gnused
, jq
, mpv
, ncurses
, ueberzug
, youtube-dl
}:

stdenv.mkDerivation rec {
  pname = "ytfzf";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "pystardust";
    repo = "ytfzf";
    rev = "v${version}";
    sha256 = "sha256-ST6ZSNJW4Pe8fdwRsQ0BLdCd3AE9OTG6is3J+HMdIzs=";
  };

  patches = [
    # Updates have to be installed through Nix.
    ./no-update.patch
  ];

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [ "PREFIX=${placeholder "out"}/bin" ];

  dontBuild = true;

  postInstall = ''
    wrapProgram "$out/bin/ytfzf" --prefix PATH : ${lib.makeBinPath [
      coreutils curl dmenu fzf gnused jq mpv ncurses ueberzug youtube-dl
    ]}
  '';

  meta = with lib; {
    description = "A posix script to find and watch youtube videos from the terminal";
    homepage = "https://github.com/pystardust/ytfzf";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
