{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frangipanni";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "birchb1024";
    repo = "frangipanni";
    rev = "v${version}";
    sha256 = "sha256-RzXfsaT/CUyWCpB5JGgl511gxgvzerqgwjpORgzyPCQ=";
  };

  vendorSha256 = "sha256-TSN5M/UCTtfoTf1hDCfrJMCFdSwL/NVXssgt4aefom8=";

  meta = with lib; {
    description = "Convert lines of text into a tree structure";
    homepage = "https://github.com/birchb1024/frangipanni";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
