{ lib, stdenv, fetchFromGitHub, fetchpatch, makeWrapper, viu }:

stdenv.mkDerivation rec {
  pname = "uwufetch";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "TheDarkBug";
    repo = pname;
    rev = version;
    hash = "sha256-2kktKdQ1xjQRIQR2auwveHgNWGaX1jdJsdlgWrH6l2g=";
  };

  patches = [
    # cannot find images in /usr
    ./fix-paths.patch
  ];

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [
    "UWUFETCH_VERSION=${version}"
  ];

  installFlags = [
    "DESTDIR=${placeholder "out"}"
    "ETC_DIR=${placeholder "out"}"
  ];

  postPatch = ''
    substituteAllInPlace uwufetch.c
  '';

  postFixup = ''
    wrapProgram $out/bin/uwufetch \
      --prefix PATH ":" ${lib.makeBinPath [ viu ]}
  '';

  meta = with lib; {
    description = "A meme system info tool for Linux";
    homepage = "https://github.com/TheDarkBug/uwufetch";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lourkeur ];
  };
}
