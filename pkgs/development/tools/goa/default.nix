{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goa";
  version = "3.11.3";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    sha256 = "sha256-Po5i6pb7Qu6kYLO7rdW9SJFDf42rPx8mvSfNxtW3Qcg=";
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
