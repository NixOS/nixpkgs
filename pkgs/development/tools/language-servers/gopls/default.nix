{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gopls";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "gopls/v${version}";
    hash = "sha256-fRpVAYg4UwRe3bcjQPOnCGWSANfoTwD5Y9vs3QET1eM=";
  };

  modRoot = "gopls";
  vendorHash = "sha256-9d7vgCMc1M5Cab+O10lQmKGfL9gqO3sajd+3rF5cums=";

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
