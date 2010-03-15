{stdenv, fetchurl, qt, perl}:

stdenv.mkDerivation rec {
  name = "qshowdiff-1.2";
  
  src = fetchurl {
    url = http://qshowdiff.danfis.cz/files/qshowdiff-1.2.tar.gz;
    sha256 = "0i3ssvax4xync9c53jaxribazvh8d8v148l3yiqsfjmqsggw9rh3";
  };

  buildInputs = [ qt perl ];

  configurePhase = ''
    ensureDir $out/{bin,man/man1}
    makeFlags="PREFIX=$out"
  '';

  meta = {
    homepage = http://qshowdiff.danfis.cz/;
    description = "Colourful diff viewer";
    license = "GPLv3+";
  };
}
