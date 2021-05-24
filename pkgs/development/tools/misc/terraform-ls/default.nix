{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-ls";
  version = "0.16.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5+h1fyTCp1jUZeKRCeDhfqAA11SMyR5nw2Y2x6JyIwY=";
  };
  vendorSha256 = "sha256-m5ddUwuTX0mSihkoGIMQKidptwUL8Bao5HgHJBWX0os=";

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
