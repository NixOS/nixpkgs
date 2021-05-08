{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-ls";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8Bo6ZSpecdMX/Hoj0N1/iptfqybPUoQ0T9IQima+Bbo=";
  };
  vendorSha256 = "sha256-oP7ZekG7YdRhUvt48wxalt8y8QmVFkAw9GRIKBmi9sg=";

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
