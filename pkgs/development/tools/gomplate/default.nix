{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gomplate";
  version = "3.11.2";
  owner = "hairyhenderson";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit owner rev;
    repo = pname;
    sha256 = "sha256-NIepoz1JToaX2EJCL/kqkpBJigJVy2Tkz0jGn4ukfvI=";
  };

  vendorSha256 = "sha256-fXbwNX+GoujciZVxxe7Tl21MxWhyAD4cW/p8PCAAElw=";

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
