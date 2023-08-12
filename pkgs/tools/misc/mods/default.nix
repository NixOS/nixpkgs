{ lib
, buildGoModule
, fetchFromGitHub
, gitUpdater
, testers
, mods
}:

buildGoModule rec {
  pname = "mods";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "mods";
    rev = "v${version}";
    hash = "sha256-jOvXT/KAfSN9E4ZgntCbTu05VJu1jhGtv6gEgLStd98=";
  };

  vendorHash = "sha256-GNGX8dyTtzRSUznEV/do1H7GEf6nYf0w+CLCZfkktfg=";

  ldflags = [ "-s" "-w" "-X=main.version=${version}" ];

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
  };
}
