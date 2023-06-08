{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, perl
, wrapGAppsHook
, openssl
, alsa-lib
, at-spi2-atk
}:

rustPlatform.buildRustPackage rec {
  pname = "phira";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "TeamFlos";
    repo = pname;
    rev = "666797936a05743c4e2c45646a7873381210590c";
    hash = "sha256-JxsZ4UAvYtu5X7qGFLSsi1FgRQ0bpeVDquad4F0Cdsc=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "macroquad-0.3.25" = "sha256-mfj5NqoZaEJ2lxZf9gC0izhaNyvWHe4Dqk7UIFGbH8I=";
      "miniquad-0.3.15" = "sha256-enX7pJgRX2OQ7PX2SAKhzU/xoB/tT3WzS4OkEmgmPOA=";
      "phira-mp-client-0.1.0" = "sha256-nMmr5An13zdSUBW/tUz1q8mHWXTiV+buWcBM05DBpQQ=";
      "sasa-0.1.0" = "sha256-NI1e3chagF//h6hwDckU1qOPkG1V7abxa5mVws4Uvfw=";
    };
  };

  postPatch = ''
    cp ${cargoLock.lockFile} Cargo.lock
  '';

  nativeBuildInputs = [
    pkg-config
    perl # openssl-sys
    wrapGAppsHook
  ];

  buildInputs = [
    openssl
    alsa-lib
    at-spi2-atk
  ];

  meta = with lib; {
    description = "a non-commercial community-driven rhythm game inspired by Phigros";
    homepage = "https://github.com/TeamFlos/phira";
    license = licenses.gpl3Plus;
    mainProgram = "phira-main";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.unix;
  };
}
