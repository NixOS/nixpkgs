{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tflint";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "wata727";
    repo = pname;
    rev = "v${version}";
    sha256 = "0x9kh0bvbil6z09v41gzk5sdiprqg288jfcjw1n2x809sj7c6vhf";
  };

  modSha256 = "0wig41m81kmy7l6sj6kk4ryc3m1b18n2vlf80x0bbhn46kyfnbgr";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Terraform linter focused on possible errors, best practices, and so on";
    homepage = "https://github.com/wata727/tflint";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
