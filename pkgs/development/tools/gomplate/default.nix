{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gomplate";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "hairyhenderson";
    repo = "gomplate";
    rev = "refs/tags/v${version}";
    hash = "sha256-+oc7/CFqLA1xvA1c5opKBUa+6AJ2SK7SwFeaNqw3x08=";
  };

  vendorHash = "sha256-xifJNyw8BCRoQVyBvyRRA1S03e3x5/ORwjpmGlKcA0g=";

  ldflags = [
    "-s"
    "-X github.com/${src.owner}/${pname}/v4/version.Version=${version}"
  ];

  preCheck = ''
    # some tests require network access
    rm net/net_test.go \
      internal/tests/integration/datasources_blob_test.go \
      internal/tests/integration/datasources_git_test.go \
      render_test.go
    # some tests rely on external tools we'd rather not depend on
    rm internal/tests/integration/datasources_consul_test.go \
      internal/tests/integration/datasources_vault*_test.go
  '';

  postInstall = ''
    rm $out/bin/gen
  '';

  meta = with lib; {
    description = "Flexible commandline tool for template rendering";
    mainProgram = "gomplate";
    homepage = "https://gomplate.ca/";
    changelog = "https://github.com/hairyhenderson/gomplate/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ris jlesquembre ];
  };
}
