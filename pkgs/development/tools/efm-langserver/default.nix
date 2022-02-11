{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "efm-langserver";
  version = "0.0.40";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "efm-langserver";
    rev = "v${version}";
    sha256 = "sha256-0C7iSWO7zzOhPgzxj9k2MK6poi4XaCbMjTGah3ohVJg=";
  };

  vendorSha256 = "sha256-tca+1SRrFyvU8ttHmfMFiGXd1A8rQSEWm1Mc2qp0EfI=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "General purpose Language Server";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/mattn/efm-langserver";
    license = licenses.mit;
  };
}
