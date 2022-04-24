{ lib, buildGoModule, fetchFromGitea }:

buildGoModule rec {
  pname = "tea";
  version = "0.8.0";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "tea";
    rev = "v${version}";
    sha256 = "sha256-LtLel6JfmYr2Zu7g7oBjAqDcl5y7tJL3XGL7gw+kHxU=";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "Gitea official CLI client";
    homepage    = "https://gitea.com/gitea/tea";
    license     = licenses.mit;
    maintainers = [ maintainers.j4m3s ];
  };
}
