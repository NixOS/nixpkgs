# Gomplate 3.x does not build with go > 1.20.
# Version 4 of gomplate (yet unreleased) should not have this issue.
#
# see https://github.com/hairyhenderson/gomplate/issues/1872

{ lib
#, buildGoModule
, buildGo120Module
, fetchFromGitHub
}:

# buildGoModule rec {
buildGo120Module rec {
  pname = "gomplate";
  version = "3.11.7";

  src = fetchFromGitHub {
    owner = "hairyhenderson";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-0cYQ44SF8fQ5Ml0tRUbqTFZ+zDVTV6elox1q6tNsG7Q=";
  };

  vendorHash = "sha256-8siITXKIqDbph/74aBEvkbLVqHE30VyRompFL6z92zA=";

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
