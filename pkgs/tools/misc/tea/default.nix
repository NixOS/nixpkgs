{ lib, buildGoModule, fetchFromGitea }:

buildGoModule rec {
  pname = "tea";
  version = "0.9.2";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "tea";
    rev = "v${version}";
    sha256 = "sha256-sZfg8+LIu1Ejvmr/o4X3EOz3fv+RvLhrGRf2yy+6t8c=";
  };

  vendorHash = "sha256-nb0lQEAaIYlGpodFQLhMk/24DmTgg5K3zQ4s/XY+Z1w=";

  meta = with lib; {
    description = "Gitea official CLI client";
    homepage    = "https://gitea.com/gitea/tea";
    license     = licenses.mit;
    maintainers = with maintainers; [ j4m3s techknowlogick ];
  };
}
