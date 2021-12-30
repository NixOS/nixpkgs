{ lib, stdenv, fetchurl, flex, makeWrapper, gnuchess, testVersion }:

stdenv.mkDerivation rec {
  pname = "gnuchess";
  version = "6.2.9";

  src = fetchurl {
    url = "mirror://gnu/chess/gnuchess-${version}.tar.gz";
    sha256 = "sha256-3fzCC911aQCpq2xCx9r5CiiTv38ZzjR0IM42uuvEGJA=";
  };

  buildInputs = [
    flex
  ];
  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/gnuchessx --set PATH "$out/bin"
    wrapProgram $out/bin/gnuchessu --set PATH "$out/bin"
  '';

  passthru.tests.version = testVersion { package = gnuchess; };

  meta = with lib; {
    description = "GNU Chess engine";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
}
