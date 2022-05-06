{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cassowary";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "rogerwelin";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rQNrxAKf2huY9I6iqdf1iYxgXaQI0LG1Lkrnv1OuJsg=";
  };

  vendorSha256 = "sha256-hGpiL88x2roFEjJJM4CKyt3k66VK1pEnpOwvhDPDp6M=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/rogerwelin/cassowary";
    description = "Modern cross-platform HTTP load-testing tool written in Go";
    license = licenses.mit;
    maintainers = with maintainers; [ hugoreeves ];
    platforms = platforms.unix;
  };
}
