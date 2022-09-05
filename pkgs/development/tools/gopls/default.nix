{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gopls";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "gopls/v${version}";
    sha256 = "sha256-4bhKNMhC8kLRpS5DR6tLF7MgDX4LDeSKoeXcPYC2ywE=";
  };

  modRoot = "gopls";
  vendorSha256 = "sha256-r7XM7VX0VzFlUqrtvaQaiUXXiD1Vz4C3hmxRMonORAw=";

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
