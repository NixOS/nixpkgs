{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "diffoci";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "reproducible-containers";
    repo = "diffoci";
    rev = "v${version}";
    hash = "sha256-Rrwwo1OCE2gn6MGt5XVddb8bJtoN7iAtxzr2MxyHcwk=";
  };

  vendorHash = "sha256-18rsa91PiqZv70EK3K6K1l6N2mIpoVpkX29amKCo5cg=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Diff for Docker and OCI container images";
    homepage = "https://github.com/reproducible-containers/diffoci/";
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}
