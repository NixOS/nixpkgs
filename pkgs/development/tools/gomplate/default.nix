{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gomplate";
  version = "3.11.8";

  src = fetchFromGitHub {
    owner = "hairyhenderson";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-pE9TLEBY1KQvgMFwVJfn5kojESqZURcbCwRt4jrexhk=";
  };

  vendorHash = "sha256-09QUEudbWnO11iwJafF9zoYqbTr7SVBUiPWTHGnZ06Q=";

  postPatch = ''
    # some tests require network access
    rm net/net_test.go \
      internal/tests/integration/datasources_blob_test.go \
      internal/tests/integration/datasources_git_test.go
    # some tests rely on external tools we'd rather not depend on
    rm internal/tests/integration/datasources_consul_test.go \
      internal/tests/integration/datasources_vault*_test.go
  '';

  # TestInputDir_RespectsUlimit
  preCheck = ''
    ulimit -n 1024
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/${src.owner}/${pname}/v3/version.Version=${version}"
  ];

  meta = with lib; {
    description = "Flexible commandline tool for template rendering";
    mainProgram = "gomplate";
    homepage = "https://gomplate.ca/";
    changelog = "https://github.com/hairyhenderson/gomplate/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      ris
      jlesquembre
    ];
  };
}
