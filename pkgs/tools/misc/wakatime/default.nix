{ lib, buildGoModule, fetchFromGitHub, testers, wakatime }:

buildGoModule rec {
  pname = "wakatime";
  version = "1.68.1";

  src = fetchFromGitHub {
    owner = "wakatime";
    repo = "wakatime-cli";
    rev = "v${version}";
    hash = "sha256-Q9LmQEcw3oehGE4DXIzQERNEZgwRzb1o8/qGOC1JGZc=";
  };

  vendorHash = "sha256-KY4niegPSLOILZgC7H7TFK6r5v3mjN9sUA5c8AuaOys=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/wakatime/wakatime-cli/pkg/version.Version=${version}"
  ];

  preCheck =
    let
      skippedTests = [
        "TestFileExperts"
        "TestSendHeartbeats"
        "TestSendHeartbeats_ExtraHeartbeats"
        "TestSendHeartbeats_IsUnsavedEntity"
        "TestSendHeartbeats_NonExistingExtraHeartbeatsEntity"
      ];
    in
    ''
      # Disable tests requiring network
      buildFlagsArray+=("-run" "[^(${builtins.concatStringsSep "|" skippedTests})]")
    '';

  passthru.tests.version = testers.testVersion {
    package = wakatime;
    command = "HOME=$(mktemp -d) wakatime-cli --version";
  };

  meta = with lib; {
    homepage = "https://wakatime.com/";
    description = "WakaTime command line interface";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "wakatime-cli";
  };
}
