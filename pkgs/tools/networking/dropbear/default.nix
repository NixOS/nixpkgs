{ stdenv, fetchurl, zlib, enableStatic ? false }:

stdenv.mkDerivation rec {
  name = "dropbear-0.52";

  src = fetchurl {
    url = http://matt.ucc.asn.au/dropbear/releases/dropbear-0.52.tar.bz2;
    sha256 = "1h84dwld8qm19m0a1zslm2ssz65nr93irw7p2h5fjrlh9ix74ywc";
  };

  dontDisableStatic = enableStatic;

  configureFlags = stdenv.lib.optional enableStatic "LDFLAGS=-static";

  buildInputs = [ zlib ];

  meta = {
    homepage = http://matt.ucc.asn.au/dropbear/dropbear.html;
    description = "An small footprint implementation of the SSH 2 protocol";
    license = "mit";
  };
}
