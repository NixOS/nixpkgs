{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gomplate";
  version = "3.11.5";

  src = fetchFromGitHub {
    owner = "hairyhenderson";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-cBSOfjU7A6B7+5zQLGtGLx9kORsjH/IzGgkjwjjTcYY=";
  };

  vendorHash = "sha256-thsa15CDD7+gCSPSU4xDbovETREeuL4gV6TjdcImj9w=";

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
    description = "A flexible commandline tool for template rendering";
    homepage = "https://gomplate.ca/";
    changelog = "https://github.com/hairyhenderson/gomplate/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ris jlesquembre ];
  };
}
