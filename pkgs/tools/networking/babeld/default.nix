{ stdenv, fetchurl, nixosTests }:

stdenv.mkDerivation rec {
  pname = "babeld";
  version = "1.9.2";

  src = fetchurl {
    url = "http://www.pps.univ-paris-diderot.fr/~jch/software/files/${pname}-${version}.tar.gz";
    sha256 = "01vzhrspnm4sy9ggaz9n3bfl5hy3qlynr218j3mdcddzm3h00kqm";
  };

  preBuild = ''
    makeFlags="PREFIX=$out ETCDIR=$out/etc"
  '';

  passthru.tests.babeld = nixosTests.babeld;

  meta = {
    homepage = "http://www.pps.univ-paris-diderot.fr/~jch/software/babel/";
    description = "Loop-avoiding distance-vector routing protocol";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ fpletz ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
