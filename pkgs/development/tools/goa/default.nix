{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goa";
  version = "3.11.2";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    sha256 = "sha256-zKiGPXkVAeWj9RXuFWvlSz1SYO+uGNBM65+ypIPZpmc=";
  };
  vendorHash = "sha256-vND29xb5bG+MnBiOCP9PWC+VGqIwdUO0uVOcP5Wc4zA=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
