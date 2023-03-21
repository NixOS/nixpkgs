{ lib, buildGoModule, fetchFromGitHub, testers, wakatime }:

buildGoModule rec {
  pname = "wakatime";
  version = "1.68.3";

  src = fetchFromGitHub {
    owner = "wakatime";
    repo = "wakatime-cli";
    rev = "v${version}";
    hash = "sha256-LifMxov7j2yRDtwh74RjjwfcHfFc/zWrzX96vb2hI9o=";
  };

  vendorHash = "sha256-SlYYrlRDBvhNm2BxemK9HzzsqM/RGH/sDQXpoGEY8rw=";

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
