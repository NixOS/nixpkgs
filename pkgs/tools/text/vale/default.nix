{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vale";
  version = "3.2.1";

  subPackages = [ "cmd/vale" ];
  outputs = [ "out" "data" ];

  src = fetchFromGitHub {
    owner = "errata-ai";
    repo = "vale";
    rev = "v${version}";
    hash = "sha256-e3cxUO05OU1RYINX24E8XXkxPADWpaIYTUgbcQIys7w=";
  };

  vendorHash = "sha256-KxIQZViUYT4cgRlOuKBwen6pqQjGiAofkeBztmjnKdQ=";

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
