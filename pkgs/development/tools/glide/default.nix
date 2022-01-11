{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "glide";
  version = "0.13.3";

  goPackagePath = "github.com/Masterminds/glide";

  ldflags = [
    "-X main.version=${version}"
  ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "Masterminds";
    repo = "glide";
    sha256 = "1wskg1cxqy9sp0738qiiagdw09dbs3swxsk4z6w5hsfiq2h44a54";
  };

  meta = with lib; {
    homepage = "https://glide.sh";
    description = "Package management for Go";
    license = licenses.mit;
    maintainers = [ maintainers.rushmorem ];
  };
}
