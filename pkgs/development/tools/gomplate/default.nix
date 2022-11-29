{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gomplate";
  version = "3.11.3";
  owner = "hairyhenderson";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit owner rev;
    repo = pname;
    sha256 = "sha256-NvTwiGyBHhHiVHdWeXnJONNkHkrvsc1zmHPK8rSHaQw=";
  };

  vendorSha256 = "sha256-BIcOErtlcnE70Mo6fjmA/btvSpw95RaKLqNWsgyJgpc=";

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
    "-X github.com/${owner}/${pname}/v3/version.Version=${rev}"
  ];

  meta = with lib; {
    description = "A flexible commandline tool for template rendering";
    homepage = "https://gomplate.ca/";
    maintainers = with maintainers; [ ris jlesquembre ];
    license = licenses.mit;
  };
}
