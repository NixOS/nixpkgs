{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gotemplate";
  version = "3.7.5";

  src = fetchFromGitHub {
    owner = "coveooss";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-BMZyq7fa57WaE0cSkGjHWxtEnbC7vEy+kLaHDoI/KZU=";
  };

  vendorHash = "sha256-uRB3atrJ+A1/xXvgmkyM/AKN+9VKSIDvsnPIdtsc3vc=";

  meta = with lib; {
    description = "CLI for go text/template";
    changelog = "https://github.com/coveooss/gotemplate/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ giorgiga ];
  };
}
