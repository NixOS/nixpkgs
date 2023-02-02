{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, ronn
, systemd
, kmod
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "zram-generator";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "systemd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-n+ZOWU+sPq9DcHgzQWTxxfMmiz239qdetXypqdy33cM=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  # RFE: Include Cargo.lock in sources
  # https://github.com/systemd/zram-generator/issues/65
  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
    substituteInPlace src/generator.rs \
      --replace 'Command::new("systemd-detect-virt")' 'Command::new("${systemd}/bin/systemd-detect-virt")' \
      --replace 'Command::new("modprobe")' 'Command::new("${kmod}/bin/modprobe")'
  '';

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
    pkg-config
    ronn
  ];

  buildInputs = [
    systemd
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "SYSTEMD_SYSTEM_UNIT_DIR=$(out)/lib/systemd/system"
    "SYSTEMD_SYSTEM_GENERATOR_DIR=$(out)/lib/systemd/system-generators"
  ];

  passthru = {
    tests = {
      inherit (nixosTests) zram-generator;
    };
    updateScript = ./update.sh;
  };

  meta = with lib; {
    homepage = "https://github.com/systemd/zram-generator";
    license = licenses.mit;
    description = "Systemd unit generator for zram devices";
    maintainers = with maintainers; [ nickcao ];
  };
}
