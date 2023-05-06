{ lib
, flutter
, fetchFromGitHub
}:

flutter.buildFlutterApplication {
  pname = "firmware-updater";
  version = "unstable-2023-04-30";

  pubspecLockFile = ./pubspec.lock;
  depsListFile = ./deps.json;
  vendorHash = "sha256-cdMO+tr6kYiN5xKXa+uTMAcFf2C75F3wVPrn21G4QPQ=";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "firmware-updater";
    rev = "6e7dbdb64e344633ea62874b54ff3990bd3b8440";
    sha256 = "sha256-s5mwtr5MSPqLMN+k851+pFIFFPa0N1hqz97ys050tFA=";
    fetchSubmodules = true;
  };

  meta = with lib; {
    description = "Firmware Updater for Linux";
    homepage = "https://github.com/canonical/firmware-updater";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mkg20001 ];
    platforms = platforms.linux;
  };
}
