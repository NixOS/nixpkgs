{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vale";
  version = "3.0.5";

  subPackages = [ "cmd/vale" ];
  outputs = [ "out" "data" ];

  src = fetchFromGitHub {
    owner = "errata-ai";
    repo = "vale";
    rev = "v${version}";
    hash = "sha256-tRsfmQ3FkRQgIg3lD8xjbn1iV2QcwDdW5pmKh96+2Gs=";
  };

  vendorHash = "sha256-AsBbJJQs+pU2UNfEFvNnPwaaabTrXvFBQLcriIA2ST4=";

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
