{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "act";
  version = "0.2.42";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+1ciEHBMl78aFDu/NzIAdsGtAZJOfHZRDDZCR1+YuEM=";
  };

  vendorHash = "sha256-qXjDeR0VZyyhASpt6zv6OyltEZDoguILhhD1ejpd0F4=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Run your GitHub Actions locally";
    homepage = "https://github.com/nektos/act";
    changelog = "https://github.com/nektos/act/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne SuperSandro2000 ];
  };
}
