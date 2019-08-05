{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tflint";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "wata727";
    repo = pname;
    rev = "v${version}";
    sha256 = "10saljrman41pjmjhbzan8jw8jbz069yhcf6vvzxmw763x5s3n85";
  };

  modSha256 = "0zfgyv1m7iay3brkqmh35gw1giyr3i3ja56dh4kgm6ai4z1jmvgc";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Terraform linter focused on possible errors, best practices, and so on";
    homepage = "https://github.com/wata727/tflint";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
