{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goa";
  version = "3.13.2";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    sha256 = "sha256-TGTFfwkRvrE2sbqPqx1YKR2w9vZ5veYEV+8CRZPWT5Y=";
  };
  vendorHash = "sha256-Twoafjo1ZBzrXZFPZn5uz+khZ3nNTbMVaqxdNIRXRQ4=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
