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
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "pystardust";
    repo = "ytfzf";
    rev = "v${version}";
    sha256 = "1i9ya38zcaj1vkfgy1n4gp5vqb59zlrd609pdmz4jqinrb0c5fgv";
  };

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [ "PREFIX=${placeholder "out"}/bin" ];

  dontBuild = true;

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
