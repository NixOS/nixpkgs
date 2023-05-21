{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gotemplate";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "coveooss";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-1jyTZBkt+nN52jgs5XZN22zw33i0yENDc4cW/Y1Lidc=";
  };

  vendorHash = "sha256-WW7X3rURdvmSjbtRkeLoicsiqxsMED5el+Jl5yYk7hA=";

  meta = with lib; {
    description = "CLI for go text/template";
    changelog = "https://github.com/coveooss/gotemplate/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ giorgiga ];
  };
}
