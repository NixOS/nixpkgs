{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tflint";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "wata727";
    repo = pname;
    rev = "v${version}";
    sha256 = "0aw39xv6jpnhy201gp9jhz6cbz47k7qgxgcwsffak8janbk6bj2a";
  };

  modSha256 = "1facqppgpmmz2j7j77fa3mnjv2nzjxz4ya6xvyvyy92ma0ybclgh";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Terraform linter focused on possible errors, best practices, and so on";
    homepage = "https://github.com/wata727/tflint";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
