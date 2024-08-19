{ lib
, stdenv
, fetchFromGitHub
, bash
, btrfs-progs
, coreutils
, python3Packages
, util-linux
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "bees";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "Zygo";
    repo = "bees";
    rev = "v${version}";
    hash = "sha256-f3P3BEd8uO6QOZ1/2hBzdcuOSggYvHxW3g9pGftKO8g=";
  };

  buildInputs = [
    btrfs-progs # for btrfs/ioctl.h
    util-linux # for uuid.h
  ];

  nativeBuildInputs = [
    python3Packages.markdown # documentation build
  ];

  preBuild = ''
    git() { if [[ $1 = describe ]]; then echo ${version}; else command git "$@"; fi; }
    export -f git
  '';

  postBuild = ''
    unset -f git
  '';

  inherit bash bees coreutils;
  utillinux = util-linux;
  btrfsProgs = btrfs-progs;
  postInstall = ''
    substituteAll ${./bees-service-wrapper} "$out"/bin/bees-service-wrapper
    chmod +x "$out"/bin/bees-service-wrapper
  '';

  buildFlags = [
    "ETC_PREFIX=/var/run/bees/configs"
  ];

  makeFlags = [
    "SHELL=bash"
    "PREFIX=$(out)"
    "ETC_PREFIX=$(out)/etc"
    "BEES_VERSION=${version}"
    "SYSTEMD_SYSTEM_UNIT_DIR=$(out)/etc/systemd/system"
  ];

  passthru.tests = {
    smoke-test = nixosTests.bees;
  };

  meta = with lib; {
    homepage = "https://github.com/Zygo/bees";
    description = "Block-oriented BTRFS deduplication service";
    longDescription = "Best-Effort Extent-Same: bees finds not just identical files, but also identical extents within files that differ";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ chaduffy ];
  };
}
