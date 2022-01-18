{ stdenv, fetchurl, apacheHttpd, perl, nixosTests }:

stdenv.mkDerivation rec {
  pname = "mod_perl";
  version = "2.0.11";

  src = fetchurl {
    url = "mirror://apache/perl/${pname}-${version}.tar.gz";
    sha256 = "0x3gq4nz96y202cymgrf56n8spm7bffkd1p74dh9q3zrrlc9wana";
  };

  patches = [
    # Fix build on perl-5.34.0, https://github.com/Perl/perl5/issues/18617
    ../../../../development/perl-modules/mod_perl2-PL_hash_seed.patch
  ];

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
