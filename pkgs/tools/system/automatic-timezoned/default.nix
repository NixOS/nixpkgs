{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "automatic-timezoned";
<<<<<<< HEAD
  version = "1.0.125";
=======
  version = "1.0.87";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "maxbrunet";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-gXuAgiz4pqc1UXTqU47G8Dve+RdCM/61jIROzy6bzII=";
  };

  cargoHash = "sha256-8zW5CHgAZHMcIIhtyjf4WA/lB+eUWiH/Nu4vkwrAx3Q=";
=======
    sha256 = "sha256-em+uGqws+cwHFIh4G8TzBbXaNNdjlhQpnjqxsGlgSo0=";
  };

  cargoHash = "sha256-s/QWLddWj0SfAK8reoi7QHPEsmNMa0igtV2TDwqA4WA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Automatically update system timezone based on location";
    homepage = "https://github.com/maxbrunet/automatic-timezoned";
    changelog = "https://github.com/maxbrunet/automatic-timezoned/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3;
    maintainers = with maintainers; [ maxbrunet ];
    platforms = platforms.linux;
  };
}
