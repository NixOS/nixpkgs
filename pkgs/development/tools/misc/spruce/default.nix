{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "spruce";
  version = "1.31.0";

  src = fetchFromGitHub {
    owner = "geofffranks";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7BZl3GPEuXdZptbkChlmdUkxfIkA3B3IdPFO46zejQ4=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "A BOSH template merge tool";
    homepage = "https://github.com/geofffranks/spruce";
    license = licenses.mit;
    maintainers = with maintainers; [ risson ];
  };
}
