{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pup";
  version = "unstable-2019-09-19";

  src = fetchFromGitHub {
    owner = "ericchiang";
    repo = "pup";
    rev = "681d7bb639334bf485476f5872c5bdab10931f9a";
    sha256 = "1hx1k0qlc1bq6gg5d4yprn4d7kvqzagg6mi5mvb39zdq6c4y17vr";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "Parsing HTML at the command line";
    homepage = "https://github.com/ericchiang/pup";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 yana ];
  };
}
