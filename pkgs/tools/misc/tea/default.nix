{ lib, buildGoModule, fetchFromGitea }:

buildGoModule rec {
  pname = "tea";
  version = "0.9.0";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "tea";
    rev = "v${version}";
    sha256 = "sha256-Bvee8m/BXvPtaaD8xjVg9qzorO0ln6xHP1upPgWoD+A=";
  };

  vendorSha256 = "sha256-nb0lQEAaIYlGpodFQLhMk/24DmTgg5K3zQ4s/XY+Z1w=";

  meta = with lib; {
    description = "Gitea official CLI client";
    homepage    = "https://gitea.com/gitea/tea";
    license     = licenses.mit;
    maintainers = with maintainers; [ j4m3s techknowlogick ];
  };
}
