{ lib
, stdenv
, fetchurl
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "babeld";
  version = "1.13";

  src = fetchurl {
    url = "https://www.irif.fr/~jch/software/files/${pname}-${version}.tar.gz";
    hash = "sha256-0IXMzPsGoR1/pbVMUdnEEPXzsKk4n1hJUTNv8Xjyk7g=";
  };

  outputs = [
    "out"
    "man"
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "ETCDIR=${placeholder "out"}/etc"
  ];

  passthru.tests.babeld = nixosTests.babeld;

  meta = with lib; {
    homepage = "http://www.irif.fr/~jch/software/babel/";
    description = "Loop-avoiding distance-vector routing protocol";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    platforms = platforms.linux;
  };
}
