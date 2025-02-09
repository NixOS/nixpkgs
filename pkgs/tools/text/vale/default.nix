{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vale";
  version = "2.30.0";

  subPackages = [ "cmd/vale" ];
  outputs = [ "out" "data" ];

  src = fetchFromGitHub {
    owner = "errata-ai";
    repo = "vale";
    rev = "v${version}";
    hash = "sha256-XTbm1wWm8+nBDN2G1Bm+FUFDV/21deGptMN5XrckMHA=";
  };

  vendorHash = "sha256-FnzuumOIvjpoDr+yBaRc8UjMDNW8mgrJiz1ZyzNW0Ts=";

  postInstall = ''
    mkdir -p $data/share/vale
    cp -r testdata/styles $data/share/vale
  '';

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "A syntax-aware linter for prose built with speed and extensibility in mind";
    homepage = "https://vale.sh/";
    changelog = "https://github.com/errata-ai/vale/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
