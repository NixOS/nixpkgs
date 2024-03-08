{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "frangipanni";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "birchb1024";
    repo = "frangipanni";
    rev = "v${version}";
    sha256 = "sha256-jIXyqwZWfCBSDTTodHTct4V5rjYv7h4Vcw7cXOFk17w=";
  };

  vendorHash = "sha256-TSN5M/UCTtfoTf1hDCfrJMCFdSwL/NVXssgt4aefom8=";

  meta = with lib; {
    description = "Convert lines of text into a tree structure";
    homepage = "https://github.com/birchb1024/frangipanni";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
