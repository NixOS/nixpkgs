{ stdenv
, lib
, fetchgit
, buildPackages
, pkgsCross
}:

stdenv.mkDerivation rec {
  pname = "mox-boot-builder";
  version = "v2022.08.30";
  src = fetchgit {
    url = "https://gitlab.nic.cz/turris/mox-boot-builder.git";
    rev = "0290b2cd9e14041ef7bcd267840f30d6c0a92ceb";
    hash = "sha256-ZlbgJj/KgiDcF7Jl+wdNJi7iSivBIGF0W1qbrcIWBvk=";
    fetchSubmodules = false;
  };

  installDir = "$out";

  nativeBuildInputs = [ pkgsCross.arm-embedded.stdenv.cc ];

  makeFlags = [
    "CROSS_CM3=${buildPackages.gcc-arm-embedded}/bin/arm-none-eabi-"
    "wtmi_app.bin"
  ];

  filesToInstall = ["wtmi_app.bin"];

  installPhase = ''
    runHook preInstall

    mkdir -p ${installDir}
    cp ${lib.concatStringsSep " " filesToInstall} ${installDir}

    runHook postInstall
  '';
  meta = with lib; {
    description = "BL32 firmware for A3700 SOCs";
    longDescription = ''
        This package contains firmware source code for a3700 chips by Marvell
    '';
    license = licenses.unfreeRedistributableFirmware;
    maintainers = [];
    platforms = platforms.linux;
  };
}
