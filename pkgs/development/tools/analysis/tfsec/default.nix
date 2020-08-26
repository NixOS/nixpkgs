{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "tfsec";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "liamg";
    repo = pname;
    rev = "v${version}";
    sha256 = "06sr20zrbhyj35cyw64bk6sjj9q9lh52kc8wg1ryaimr3dc6lrn1";
  };

  goPackagePath = "github.com/liamg/tfsec";

  buildFlagsArray = [ "-ldflags=-s -w -X ${goPackagePath}/version.Version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/liamg/tfsec";
    description = "Static analysis powered security scanner for your terraform code";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
