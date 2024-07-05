{ lib
, writeText
, flutter
, fetchFromGitHub
}:

flutter.buildFlutterApplication rec {
  pname = "firmware-updater";
  version = "unstable-2024-18-04";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  patches = [
    ./upgrade-file.patch
  ];

  sourceRoot = "./source/packages/firmware_updater";

  gitHashes = {
    fwupd = "sha256-l/+HrrJk1mE2Mrau+NmoQ7bu9qhHU6wX68+m++9Hjd4=";
  };

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "firmware-updater";
    rev = "e48bb3f693e5d76656a3e7bbc07be0fcbfa19f23";
    hash = "sha256-SO3sDIsJCK4Sh51pXO4u6WX4zcFa6jQYu9E+WtVrjDE=";
  };

  meta = with lib; {
    description = "Firmware Updater for Linux";
    mainProgram = "firmware-updater";
    homepage = "https://github.com/canonical/firmware-updater";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mkg20001 ];
    platforms = platforms.linux;
  };
}
