{ lib, buildGoPackage, fetchFromGitHub, fetchpatch }:

buildGoPackage rec {
  pname = "minio-exporter";
  version = "0.2.0";
  rev = "v${version}";

  goPackagePath = "github.com/joe-pll/minio-exporter";

  src= fetchFromGitHub {
    inherit rev;
    owner = "joe-pll";
    repo = "minio-exporter";
    sha256 = "1my3ii5s479appiapw8gjzkq1pk62fl7d7if8ljvdj6qw4man6aa";
  };

  # Required to make 0.2.0 build against latest dependencies
  # TODO: Remove on update to 0.3.0
  patches = [
    (fetchpatch {
      url = "https://github.com/joe-pll/minio-exporter/commit/50ab89d42322dc3e2696326a9ae4d3f951f646de.patch";
      sha256 = "0aiixhvb4x8c8abrlf1i4hmca9i6xd6b638a5vfkvawx0q7gxl97";
    })
  ];

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "A Prometheus exporter for Minio cloud storage server";
    mainProgram = "minio-exporter";
    homepage = "https://github.com/joe-pll/minio-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ bachp ];
    platforms = platforms.unix;
  };
}
