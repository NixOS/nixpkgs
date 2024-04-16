{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vale";
  version = "3.4.1";

  subPackages = [ "cmd/vale" ];
  outputs = [ "out" "data" ];

  src = fetchFromGitHub {
    owner = "errata-ai";
    repo = "vale";
    rev = "v${version}";
    hash = "sha256-fD2KBKDfKTNYuzP/zKkAx9h/HMxOlAyiWtp9EsWxop8=";
  };

  vendorHash = "sha256-HMzFLSmO6sBDNU89UoIvHcPPd3ubpti2ii4sFMKUDmI=";

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
    mainProgram = "vale";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
