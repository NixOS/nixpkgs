{ lib
, buildGoModule
, fetchFromGitHub
, testers
, zed
}:

buildGoModule rec {
  pname = "zed";
<<<<<<< HEAD
  version = "1.9.0";
=======
  version = "1.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "brimdata";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-aLehlxMztOqtItzouWESQs5K2EZ+O8EAwUQT9v7GX08=";
  };

  vendorHash = "sha256-n/7HV3dyV8qsJeEk+vikZvuM5G7nf0QOwVBtInJdU2k=";
=======
    sha256 = "sha256-laqHFrRp83IE75RgAmxxTsq7c48RDapAJQFXWI1NO2o=";
  };

  vendorHash = "sha256-Uy8GR+mNVElx+MOu8IxHjBhp1GT5nLqqizQH9q1s0wA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/zed" "cmd/zq" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/brimdata/zed/cli.version=${version}"
  ];

  passthru.tests = {
    zed-version = testers.testVersion {
      package = zed;
    };
    zq-version = testers.testVersion {
      package = zed;
      command = "zq --version";
    };
  };

  meta = with lib; {
    description = "A novel data lake based on super-structured data";
    homepage = "https://zed.brimdata.io";
    changelog = "https://github.com/brimdata/zed/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dit7ya knl ];
  };
}
