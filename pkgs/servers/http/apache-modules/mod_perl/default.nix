{ stdenv, fetchurl, apacheHttpd, perl }:

stdenv.mkDerivation rec {
  name = "mod_perl-2.0.8";

  src = fetchurl {
    url = "mirror://apache/perl/${name}.tar.gz";
    sha256 = "1ri01b160mbidpg5f5sdydsrja129zw2vflbx1f3j2m981x1pp1m";
  };

  buildInputs = [ apacheHttpd perl ];
  buildPhase = ''
    perl Makefile.PL \
      MP_APXS=${apacheHttpd}/bin/apxs
    make
  '';
  installPhase = ''
    mkdir -p $out
    make install DESTDIR=$out
    mv $out${apacheHttpd}/* $out
    mv $out${perl}/* $out
    rm $out/nix -rf
  '';
}
