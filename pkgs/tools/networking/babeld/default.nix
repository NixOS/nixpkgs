{ lib, stdenv, fetchurl, nixosTests }:

stdenv.mkDerivation rec {
  pname = "babeld";
  version = "1.12";

  src = fetchurl {
    url = "https://www.irif.fr/~jch/software/files/${pname}-${version}.tar.gz";
    sha256 = "sha256-gy7wgMOA/2wNcVxr+IrCL8rofcDwRWbmC+zbjYce/7k=";
  };

  preBuild = ''
    makeFlags="PREFIX=$out ETCDIR=$out/etc"
  '';

  passthru.tests.babeld = nixosTests.babeld;

  meta = with lib; {
    homepage = "http://www.irif.fr/~jch/software/babel/";
    description = "Loop-avoiding distance-vector routing protocol";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz hexa ];
    platforms = platforms.linux;
  };
}
