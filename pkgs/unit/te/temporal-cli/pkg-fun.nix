{ lib, fetchFromGitHub, buildGoModule, testers, temporal-cli }:

buildGoModule rec {
  pname = "temporal-cli";
  version = "1.17.2";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "tctl";
    rev = "v${version}";
    hash = "sha256-QID0VtARbJiTIQm2JeaejQ5VpJsAIHfZtws7i2UN8dM=";
  };

  vendorHash = "sha256-9bgovXVj+qddfDSI4DTaNYH4H8Uc4DZqeVYG5TWXTNw=";

  ldflags = [ "-s" "-w" ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  passthru.tests.version = testers.testVersion {
    package = temporal-cli;
    # the app writes a default config file at startup
    command = "HOME=$(mktemp -d) ${meta.mainProgram} --version";
  };

  meta = with lib; {
    description = "Temporal CLI";
    homepage = "https://temporal.io";
    license = licenses.mit;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "tctl";
  };
}
