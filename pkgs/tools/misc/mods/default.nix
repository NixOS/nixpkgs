{ lib
, buildGoModule
, fetchFromGitHub
, gitUpdater
, testers
, mods
}:

buildGoModule rec {
  pname = "mods";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "mods";
    rev = "v${version}";
    hash = "sha256-ecmfWnrd9gwIEGAOIcOeUnfmkKmq9dLxpKqAHJemhvU=";
  };

  vendorHash = "sha256-pJ31Lsa5VVix3BM4RrllQA3MJ/JeNIKfQ8RClyFfXCI=";

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
