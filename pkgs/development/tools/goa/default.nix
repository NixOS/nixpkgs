{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goa";
  version = "3.12.3";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    sha256 = "sha256-OWYIfzJcR0V5GogVntzu5hOe3h3JO5FYWxSqYSxRp6A=";
  };
  vendorHash = "sha256-Zt8Nzga9xRYuUv8ofCJa3yL2Kq+xvnqs3c0g2BnrgTo=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
