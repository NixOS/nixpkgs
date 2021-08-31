{ lib, buildGoModule, fetchFromGitea }:

buildGoModule rec {
  pname = "tea";
  version = "0.7.0";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "tea";
    rev = "v${version}";
    sha256 = "sha256-Kq+A6YELfBJ04t7pPnX8Ulh4NSMFn3AHggplLD9J8MY=";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "Gitea official CLI client";
    homepage    = "https://gitea.com/gitea/tea";
    license     = licenses.mit;
    maintainers = [ maintainers.j4m3s ];
  };
}
