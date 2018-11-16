{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  name = "ent-1.1";

  src = fetchurl {
    url = "https://www.fourmilab.ch/random/random.zip";
    sha256 = "1v39jlj3lzr5f99avzs2j2z6anqqd64bzm1pdf6q84a5n8nxckn1";
  };

  # Work around the "unpacker appears to have produced no directories"
  # case that happens when the archive doesn't have a subdirectory.
  setSourceRoot = "sourceRoot=`pwd`";

  buildInputs = [ unzip ];

  buildFlags = if stdenv.cc.isClang then [ "CC=clang" ] else null;

  installPhase = ''
    mkdir -p $out/bin
    cp ent $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Pseudorandom Number Sequence Test Program";
    homepage = http://www.fourmilab.ch/random/;
    platforms = platforms.all;
    license = licenses.publicDomain;
  };
}
