{ lib
, buildGoModule
, fetchFromGitHub
, gitUpdater
, testers
, mods
}:

buildGoModule rec {
  pname = "mods";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "mods";
    rev = "v${version}";
    hash = "sha256-ZWH3YuN1cmdw96/HVzsp1u70ziUfupUeBjJiNI5a538=";
  };

  vendorHash = "sha256-PgaxqfgtwBYnzyL2F/OPJP1rdmLOtBCTKEPhMgvC6XA=";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "v";
      ignoredVersions = ".(rc|beta).*";
    };

    tests.version = testers.testVersion {
      package = mods;
      command = "HOME=$(mktemp -d) mods -v";
    };
  };

  meta = with lib; {
    description = "AI on the command line";
    homepage = "https://github.com/charmbracelet/mods";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "mods";
  };
}
