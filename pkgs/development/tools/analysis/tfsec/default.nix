{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "tfsec";
  version = "0.36.10";

  src = fetchFromGitHub {
    owner = "tfsec";
    repo = pname;
    rev = "v${version}";
    sha256 = "11kv13d4cw515r79azfha1ksmvsha1rvg0jak9nvz9ggivyn0s7a";
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
