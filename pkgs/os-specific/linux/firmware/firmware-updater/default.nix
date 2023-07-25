{ lib
, flutter
, fetchFromGitHub
}:

flutter.buildFlutterApplication {
  pname = "firmware-updater";
  version = "unstable-2023-06-20";

  pubspecLockFile = ./pubspec.lock;
  depsListFile = ./deps.json;
  vendorHash = "sha256-+4Lu6yHH/Yhl58bxhsLanP5hyhXSg9LpCuG1ohAlM5g=";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "firmware-updater";
    rev = "49ebcad241ed4964f1547c8da408bef13a8b4c69";
    sha256 = "sha256-1BGcpcIJV0jqrj3nA7FJg36lMqpl281NGOgWppDUFCI=";
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
