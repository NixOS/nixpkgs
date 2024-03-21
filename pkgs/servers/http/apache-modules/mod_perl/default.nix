{
  apacheHttpd,
  directoryListingUpdater,
  fetchurl,
  lib,
  nixosTests,
  perl,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "mod_perl";
  version = "2.0.12";

  src = fetchurl {
    url = "mirror://apache/perl/${pname}-${version}.tar.gz";
    sha256 = "sha256-9bghtZsP3JZw5G7Q/PMtiRHyUSYYmotowWUvkiHu4mk=";
  };

  buildInputs = [
    apacheHttpd
    perl
  ];

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

  passthru = {
    updateScript = directoryListingUpdater {
      url = "https://archive.apache.org/dist/perl/";
    };
    tests = nixosTests.mod_perl;
  };

  meta = with lib; {
    description = "Integration of perl with the Apache2 web server";
    homepage = "https://perl.apache.org/download/index.html";
    changelog = "https://github.com/apache/mod_perl/blob/trunk/Changes";
    license = licenses.asl20;
    mainProgram = "mp2bug";
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
