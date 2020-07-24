{ stdenv, fetchurl, apacheHttpd, perl }:

stdenv.mkDerivation rec {
  name = "mod_perl-2.0.10";

  src = fetchurl {
    url = "mirror://apache/perl/${name}.tar.gz";
    sha256 = "0r1bhzwl5gr0202r6448943hjxsickzn55kdmb7dzad39vnq7kyi";
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
