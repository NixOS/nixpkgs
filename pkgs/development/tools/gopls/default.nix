{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gopls";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "gopls/v${version}";
    sha256 = "sha256-pEEqzaV3B/eDSiqJa5AZydlmYrvpD9CDryy2rHf4N5Y=";
  };

  modRoot = "gopls";
  vendorSha256 = "sha256-ZdFYAQxStbY6KPyRAHvnwPeKLrOLVrr59MMyjknyK5Y=";

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
