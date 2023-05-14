{ lib
, stdenv
, runCommand
, fetchFromGitHub
, bash
, btrfs-progs
, coreutils
, python3Packages
, util-linux
, nixosTests
}:

let

  bees = stdenv.mkDerivation rec {
    pname = "bees";
    version = "0.9.3";

    src = fetchFromGitHub {
      owner = "Zygo";
      repo = "bees";
      rev = "v${version}";
      sha256 = "sha256-krG8TzfOz3m7h3GfkBU+NJz7EdlXiWOOXY8bQRq9z4Q=";
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

    meta = with lib; {
      homepage = "https://github.com/Zygo/bees";
      description = "Block-oriented BTRFS deduplication service";
      longDescription = "Best-Effort Extent-Same: bees finds not just identical files, but also identical extents within files that differ";
      license = licenses.gpl3;
      platforms = platforms.linux;
      maintainers = with maintainers; [ chaduffy ];
    };
  };

in

(runCommand "bees-service"
  {
    inherit bash bees coreutils;
    utillinux = util-linux; # needs to be a valid shell variable name
    btrfsProgs = btrfs-progs; # needs to be a valid shell variable name
  } ''
  mkdir -p -- "$out/bin"
  substituteAll ${./bees-service-wrapper} "$out"/bin/bees-service-wrapper
  chmod +x "$out"/bin/bees-service-wrapper
  ln -s ${bees}/bin/beesd "$out"/bin/beesd
'').overrideAttrs (old: {
  passthru.tests = {
    smoke-test = nixosTests.bees;
  };
})
