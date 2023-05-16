{ lib
, fetchFromGitHub
, buildGoModule
, testers
, trufflehog
}:

buildGoModule rec {
  pname = "trufflehog";
<<<<<<< HEAD
  version = "3.54.4";
=======
  version = "3.34.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "trufflesecurity";
    repo = "trufflehog";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-VWFGM4kRPrcdRwrzKrlbHl+eCpvnpYB2MD1ziPYJwjA=";
  };

  vendorHash = "sha256-zYvKhhwN5TtJQxkkcY5U9LtTdMb97ucfksxpTMKH/Zc=";
=======
    hash = "sha256-n/IzfVB40Ufr46L83WCxIyCwB9/jYVsw/J5F34/bDLg=";
  };

  vendorHash = "sha256-wzBJjJVBT0mGJx0WQbs2D4n7ovfz1lA2NCEpz6xuqpg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=${version}"
  ];

  # Test cases run git clone and require network access
  doCheck = false;

  postInstall = ''
    rm $out/bin/{generate,snifftest}
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = trufflehog;
    };
  };

  meta = with lib; {
    description = "Find credentials all over the place";
    homepage = "https://github.com/trufflesecurity/trufflehog";
    changelog = "https://github.com/trufflesecurity/trufflehog/releases/tag/v${version}";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
