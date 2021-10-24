{ lib, stdenv, fetchFromGitHub, qt4, perl, pkg-config }:

stdenv.mkDerivation rec {
  pname = "qshowdiff";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "danfis";
    repo = "qshowdiff";
    rev = "v${version}";
    sha256 = "g3AWQ6/LSF59ztzdgNuLi+8d6fFTPiC9z0yXMdPdB5U=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ qt4 perl ];

  configurePhase = ''
    mkdir -p $out/{bin,man/man1}
    makeFlags="PREFIX=$out CC=$CXX"
  '';

  meta = {
    homepage = "http://qshowdiff.danfis.cz/";
    description = "Colourful diff viewer";
    license = lib.licenses.gpl3Plus;
  };
}
