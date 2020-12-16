{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-ls";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "XOKaNpYR31lKpA33+7WU2KYjgEx4g6gpp3IAjWtb3Zk=";
  };
  vendorSha256 = "8NdeCD558r0tV+ZR4MvLl5CzeNj8cUGtqwvJ2ZhS7mI=";

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
