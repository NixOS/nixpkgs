{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tflint";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "wata727";
    repo = pname;
    rev = "v${version}";
    sha256 = "1k050kcgvy21jk01mkgscfl7hlfgaa1621920w111fghqxibssan";
  };

  modSha256 = "17pm6v34gya8bgz8g5hh1cijjldk78j53x9yvsjpcjnqm7l0clcd";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Terraform linter focused on possible errors, best practices, and so on";
    homepage = "https://github.com/wata727/tflint";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
