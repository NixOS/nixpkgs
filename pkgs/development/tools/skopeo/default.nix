{ stdenv, lib, buildGoPackage, fetchFromGitHub, gpgme }:

buildGoPackage rec {
  name = "skopeo-${version}";
  version = "0.1.16";
  rev = "v${version}";

  goPackagePath = "github.com/projectatomic/skopeo";
  excludedPackages = "integration";

  buildInputs = [ gpgme ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "projectatomic";
    repo = "skopeo";
    sha256 = "11na7imx6yc1zijb010hx6fjh6v0m3wm5r4sa2nkclm5lkjq259b";
  };

  meta = {
    description = "A command line utility for various operations on container images and image repositories";
    homepage = "https://github.com/projectatomic/skopeo";
    maintainers = with stdenv.lib.maintainers; [ vdemeester ];
    license = stdenv.lib.licenses.asl20;
  };
}
