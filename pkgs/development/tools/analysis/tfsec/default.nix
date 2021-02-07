{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "tfsec";
  version = "0.37.3";

  src = fetchFromGitHub {
    owner = "tfsec";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-36yiX/uTqjiG+ZdQUQGPiLxSxIXE6ThH/LMqBGnm1d8=";
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
