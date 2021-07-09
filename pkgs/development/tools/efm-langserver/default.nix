{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "efm-langserver";
  version = "0.0.33";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "efm-langserver";
    rev = "v${version}";
    sha256 = "sha256-f9r1NGbyOaf9xGOuDGjyodsvEaqcMVzUiV8H2FAGXvc=";
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
