{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "act";
  version = "0.2.24";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BWSw1yELxLDMUg2LxXuy+N0IRxLQYtVdzny1FGYVXEY=";
  };

  vendorSha256 = "sha256-dLIsVWN/PjcH0CUYRmn4YaF8Pczf/gaWhD3lulqGiuA=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "Run your GitHub Actions locally";
    homepage = "https://github.com/nektos/act";
    changelog = "https://github.com/nektos/act/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne SuperSandro2000 ];
  };
}
