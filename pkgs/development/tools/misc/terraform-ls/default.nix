{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-ls";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/g62LSlaIK67oY6dI8S3Lni85eBBI6piqP2Fsq3HXWQ=";
  };
  vendorSha256 = "sha256-U0jVdyY4SifPWkOkq3ohY/LvfGcYm4rI+tW1QEm39oo=";

  # tests fail in sandbox mode because of trying to download stuff from releases.hashicorp.com
  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "Terraform Language Server (official)";
    homepage = "https://github.com/hashicorp/terraform-ls";
    license = licenses.mpl20;
    maintainers = with maintainers; [ mbaillie ];
  };
}
