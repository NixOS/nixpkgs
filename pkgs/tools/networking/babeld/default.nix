{ lib
, stdenv
, fetchurl
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "babeld";
<<<<<<< HEAD
  version = "1.13.1";

  src = fetchurl {
    url = "https://www.irif.fr/~jch/software/files/${pname}-${version}.tar.gz";
    hash = "sha256-FfJNJtoMz8Bzq83vAwnygeRoTyqnESb4JlcsTIRejdk=";
=======
  version = "1.12.2";

  src = fetchurl {
    url = "https://www.irif.fr/~jch/software/files/${pname}-${version}.tar.gz";
    hash = "sha256-HbIrYZMHDqJFChq1EZb9cvWKEyn3gMsDiOLksud2jLs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
