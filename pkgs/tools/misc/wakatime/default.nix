{ lib, buildGoModule, fetchFromGitHub, testers, wakatime }:

buildGoModule rec {
  pname = "wakatime";
  version = "1.70.1";

  src = fetchFromGitHub {
    owner = "wakatime";
    repo = "wakatime-cli";
    rev = "v${version}";
    hash = "sha256-PZIO8ULvSdsOeRLGPrsRyoql8Z4Xq7z4q/AErw239BI=";
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
        # Tests requiring network
        "TestFileExperts"
        "TestSendHeartbeats"
        "TestSendHeartbeats_ExtraHeartbeats"
        "TestSendHeartbeats_IsUnsavedEntity"
        "TestSendHeartbeats_NonExistingExtraHeartbeatsEntity"

        # Flaky tests
        "TestLoadParams_ApiKey_FromVault_Err_Darwin"
      ];
    in
    ''
      # Disable tests
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
