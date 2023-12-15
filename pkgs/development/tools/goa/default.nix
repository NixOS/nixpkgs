{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goa";
  version = "3.14.1";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    sha256 = "sha256-acF9y0EHjALB+h/mf96MfCUlSTvp3QdhwEbu3gBA/y4=";
  };
  vendorHash = "sha256-RI2UMmdFCNo6iE9MnWwsJtholjF4jNbCNNLk8nylgtc=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
