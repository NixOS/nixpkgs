{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "diffoci";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "reproducible-containers";
    repo = "diffoci";
    rev = "v${version}";
    hash = "sha256-xmsfqlp/bosCjT83MXkA7uNlPgGYlKXOdnxVhm648zo=";
  };

  vendorHash = "sha256-w3/Je8iIT6CEusfIfGv9TAWkePY5TtOQS0rQYH92sAs=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Diff for Docker and OCI container images";
    homepage = "https://github.com/reproducible-containers/diffoci/";
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
  };
}
