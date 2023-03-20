{ lib, stdenv, fetchFromGitHub, makeWrapper, imagemagick, xorg }:

stdenv.mkDerivation rec {
  pname = "ttygif";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "icholy";
    repo = pname;
    rev = version;
    sha256 = "sha256-GsMeVR2wNivQguZ6B/0v39Td9VGHg+m3RtAG9DYkNmU=";
  };

  makeFlags = [ "CC:=$(CC)" "PREFIX=${placeholder "out"}" ];

  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/ttygif \
      --prefix PATH : ${lib.makeBinPath [ imagemagick xorg.xwd ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/icholy/ttygif";
    description = "Convert terminal recordings to animated gifs";
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ moaxcp ];
  };
}
