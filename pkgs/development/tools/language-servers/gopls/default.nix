{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gopls";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "gopls/v${version}";
    sha256 = "sha256-y9FgB8Qsm5wQ7dtrKrcl/bHTw04eRU1B7a+aZmA+eBE=";
  };

  modRoot = "gopls";
  vendorSha256 = "sha256-MkldIbp7BpdfyapiJ1E4h3ft6g74zMb72tt4tCJlJz8=";

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
