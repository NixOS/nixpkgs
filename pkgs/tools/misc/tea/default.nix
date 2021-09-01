{ lib, buildGoModule, fetchFromGitea }:

buildGoModule rec {
  pname = "tea";
  version = "0.7.1";

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "tea";
    rev = "v${version}";
    sha256 = "sha256-Y/Znj8vVjVt+rs+n8JRQsptq5u17G2D7r98PDxPLyd4=";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "Gitea official CLI client";
    homepage    = "https://gitea.com/gitea/tea";
    license     = licenses.mit;
    maintainers = [ maintainers.j4m3s ];
  };
}
