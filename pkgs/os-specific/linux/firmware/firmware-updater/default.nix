{ lib
<<<<<<< HEAD
, writeText
, flutter
, fetchFromGitHub
}:

flutter.buildFlutterApplication rec {
  pname = "firmware-updater";
  version = "unstable-2023-09-17";

  pubspecLockFile = ./pubspec.lock;
  depsListFile = ./deps.json;
  vendorHash = "sha256-5xd9ppnWleKVA69DJWVdY+rZziu4dQBCu16I0ivD8kE=";
=======
, flutter37
, fetchFromGitHub
}:

flutter37.buildFlutterApplication {
  pname = "firmware-updater";
  version = "unstable-2023-04-30";

  pubspecLockFile = ./pubspec.lock;
  depsListFile = ./deps.json;
  vendorHash = "sha256-cdMO+tr6kYiN5xKXa+uTMAcFf2C75F3wVPrn21G4QPQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "firmware-updater";
<<<<<<< HEAD
    rev = "855999da8d3d0c9930e06f2d296d82b55aeff79e";
    hash = "sha256-tIeEuHl+sCKd756NYPmxXiV1Sg2m9W0eGUtM/Iskeu8=";
  };

  postPatch = ''
    rm -f pubspec.lock
    ln -s "${writeText "${pname}-overrides.yaml" (builtins.toJSON {
      dependency_overrides = {
        yaru = "^1.1.0";
        yaru_icons = "^2.2.1";
        yaru_widgets = "^3.1.0";
        mockito = "^5.4.2";
        test_api = "^0.6.1";
      };
    })}" pubspec_overrides.yaml
  '';

=======
    rev = "6e7dbdb64e344633ea62874b54ff3990bd3b8440";
    sha256 = "sha256-s5mwtr5MSPqLMN+k851+pFIFFPa0N1hqz97ys050tFA=";
    fetchSubmodules = true;
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Firmware Updater for Linux";
    homepage = "https://github.com/canonical/firmware-updater";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mkg20001 ];
    platforms = platforms.linux;
  };
}
