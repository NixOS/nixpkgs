{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gopls";
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "gopls/v${version}";
    sha256 = "sha256-OieIbWgc5l7HS6otkRxsKYQmNIjPbADQ+C3A6qJr2h0=";
  };

  modRoot = "gopls";
  vendorSha256 = "sha256-0Svz0VFmNW/f8Po+DpIQi0bJB1ICLcSJM1sG/Nju+ZY=";

  doCheck = false;

  # Only build gopls, and not the integration tests or documentation generator.
  subPackages = [ "." ];

  meta = with lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 rski SuperSandro2000 zimbatm ];
  };
}
