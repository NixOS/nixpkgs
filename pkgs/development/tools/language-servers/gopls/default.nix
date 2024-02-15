{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gopls";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "gopls/v${version}";
    hash = "sha256-hcicI5ka6m0W2Sj8IaxNsLfIc97eR8SKKp81mJvM2GM=";
  };

  modRoot = "gopls";
  vendorHash = "sha256-jjUTRLRySRy3sfUDfg7cXRiDHk1GWHijgEA5XjS+9Xo=";

  doCheck = false;

  # Only build gopls, and not the integration tests or documentation generator.
  subPackages = [ "." ];

  meta = with lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 rski SuperSandro2000 zimbatm ];
    mainProgram = "gopls";
  };
}
