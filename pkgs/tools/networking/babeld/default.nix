{ lib, stdenv, fetchurl, fetchpatch, nixosTests }:

stdenv.mkDerivation rec {
  pname = "babeld";
  version = "1.9.2";

  src = fetchurl {
    url = "http://www.pps.univ-paris-diderot.fr/~jch/software/files/${pname}-${version}.tar.gz";
    sha256 = "01vzhrspnm4sy9ggaz9n3bfl5hy3qlynr218j3mdcddzm3h00kqm";
  };

  patches = [
    (fetchpatch {
      # Skip kernel_setup_interface when `skip-kernel-setup` is enabled.
      url = "https://github.com/jech/babeld/commit/f9698a5616842467ad08a5f9ed3d6fcfa2dd2898.patch";
      sha256 = "00kj2jxsfq0pjk5wrkslyvkww57makxlwa4fd82g7g9hrgahpqwr";
    })
  ];

  preBuild = ''
    makeFlags="PREFIX=$out ETCDIR=$out/etc"
  '';

  passthru.tests.babeld = nixosTests.babeld;

  meta = {
    homepage = "http://www.pps.univ-paris-diderot.fr/~jch/software/babel/";
    description = "Loop-avoiding distance-vector routing protocol";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fpletz ];
    platforms = with lib.platforms; linux;
  };
}
