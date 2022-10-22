{ stdenv, fetchurl, apacheHttpd, perl, nixosTests }:

stdenv.mkDerivation rec {
  pname = "mod_perl";
  version = "2.0.12";

  src = fetchurl {
    url = "mirror://apache/perl/${pname}-${version}.tar.gz";
    sha256 = "sha256-9bghtZsP3JZw5G7Q/PMtiRHyUSYYmotowWUvkiHu4mk=";
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

  passthru.tests = nixosTests.mod_perl;
}
