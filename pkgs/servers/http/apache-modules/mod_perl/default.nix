{ stdenv, fetchurl, apacheHttpd, perl }:

stdenv.mkDerivation rec {
  pname = "mod_perl";
  version = "2.0.11";

  src = fetchurl {
    url = "mirror://apache/perl/${pname}-${version}.tar.gz";
    sha256 = "0x3gq4nz96y202cymgrf56n8spm7bffkd1p74dh9q3zrrlc9wana";
  };

  buildInputs = [ apacheHttpd perl ];
  buildPhase = ''
    perl Makefile.PL \
      MP_APXS=${apacheHttpd.dev}/bin/apxs
    make
  '';
  installPhase = ''
    mkdir -p $out
    make install DESTDIR=$out
    mv $out${apacheHttpd}/* $out
    mv $out${apacheHttpd.dev}/* $out
    mv $out${perl}/* $out
    rm $out/nix -rf
  '';
}
