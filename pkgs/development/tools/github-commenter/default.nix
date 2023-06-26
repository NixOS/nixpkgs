{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "github-commenter";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "cloudposse";
    repo = pname;
    rev = version;
    sha256 = "sha256-IBo4FAoYX1FmrmQ9mlyyu1TGLY7dlH7pWalBoRb2puE=";
  };

  vendorSha256 = "sha256-H1SnNG+/ALYs7h/oT8zWBhAXOuCFY0Sto2ATBBZg2ek=";

  meta = with lib; {
    description = "Command line utility for creating GitHub comments on Commits, Pull Request Reviews or Issues";
    license = licenses.asl20;
    homepage = "https://github.com/cloudposse/github-commenter";
    maintainers = [ maintainers.mmahut ];
  };
}
