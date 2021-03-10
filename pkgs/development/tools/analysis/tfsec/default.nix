{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "tfsec";
  version = "0.39.5";

  src = fetchFromGitHub {
    owner = "tfsec";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RDvwZyltPD21CQwZISOrLPVgQeRmPQc6/yssptS4XMw=";
  };

  goPackagePath = "github.com/tfsec/tfsec";

  buildFlagsArray = [ "-ldflags=-s -w -X ${goPackagePath}/version.Version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/tfsec/tfsec";
    description = "Static analysis powered security scanner for your terraform code";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
