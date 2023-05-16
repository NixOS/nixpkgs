{ lib
, buildGoModule
, fetchFromGitHub
, osv-detector
, testers
}:

buildGoModule rec {
  pname = "osv-detector";
<<<<<<< HEAD
  version = "0.11.1";
=======
  version = "0.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "G-Rath";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-vIkLrKyDeMfRe/0EPhlKlHAO6XB0/OFY5mTUHeZbcg8=";
  };

  vendorHash = "sha256-Rrosye8foVntoFDvDmyNuXgnEgjzcOXenOKBMZVCRio=";
=======
    hash = "sha256-Y/9q4ZJ4vxDitqrM4hGe49iqLYk4ebhTs4jrD7P8fdw=";
  };

  vendorSha256 = "sha256-KAxpDQIRrLZIOvfW8wf0CV4Fj6l3W6nNZNCH3ZE6yJc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-w"
    "-s"
    "-X main.version=${version}"
  ];

<<<<<<< HEAD
  checkFlags =
    let
      skippedTests = [
        # Disable tests requiring network access
        "TestRun_ParseAs_CsvFile"
        "TestRun_ParseAs_CsvRow"
        "TestRun_DBs"
        "TestRun_Lockfile"
        "TestRun_ParseAsGlobal"
        "TestRun_Ignores"
        "TestRun_ParseAsSpecific"
        "TestRun_Configs"
      ];
    in
    [ "-skip" "${builtins.concatStringsSep "|" skippedTests}" ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  passthru.tests.version = testers.testVersion {
    package = osv-detector;
    command = "osv-detector -version";
    version = "osv-detector ${version} (unknown, commit none)";
  };

  meta = with lib; {
    description = "Auditing tool for detecting vulnerabilities";
    homepage = "https://github.com/G-Rath/osv-detector";
    changelog = "https://github.com/G-Rath/osv-detector/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
