{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gomplate";
  version = "3.10.0";
  owner = "hairyhenderson";
  rev = "v${version}";

  src = fetchFromGitHub {
    inherit owner rev;
    repo = pname;
    sha256 = "0dbi9saxbwcvypxc0s656ln9zq2vysx8dhrcz488nmy6rcpqiiah";
  };

  vendorSha256 = "0rvki8ghlbbaqgnjfsbs1jswj08jfzmnz9ilynv2c6kfkx9zs108";

  postPatch = ''
    # some tests require network access
    rm net/net_test.go \
      internal/tests/integration/datasources_blob_test.go \
      internal/tests/integration/datasources_git_test.go
    # some tests rely on external tools we'd rather not depend on
    rm internal/tests/integration/datasources_consul_test.go \
      internal/tests/integration/datasources_vault*_test.go
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
