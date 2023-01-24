{ stdenv
, lib
, fetchFromGitLab
, buildPackages
}:

stdenv.mkDerivation rec {
  pname = "nic-cz-armada-bl32-unsigned-firmware";
  version = "v2022.06.11-7-g0290b2c";
  src = fetchFromGitLab {
    domain = "gitlab.nic.cz";
    owner = "turris";
    repo = "mox-boot-builder";
    rev = "0290b2cd9e14041ef7bcd267840f30d6c0a92ceb";
    hash = "sha256-ZlbgJj/KgiDcF7Jl+wdNJi7iSivBIGF0W1qbrcIWBvk=";
    fetchSubmodules = false;
  };

  nativeBuildInputs = [ 
    buildPackages.stdenv.cc
  ];

  makeFlags = [
    "CROSS_CM3=${buildPackages.gcc-arm-embedded}/bin/arm-none-eabi-"
    "WTMI_VERSION=${version}"
    "wtmi_app.bin"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp wtmi_app.bin $out

    runHook postInstall
  '';
  meta = with lib; {
    description = "BL32 firmware for A3700 SOCs";
    longDescription = ''
        This package contains firmware source code for a3700 chips by Marvell
    '';
    license = licenses.unfreeRedistributableFirmware;
    maintainers = with maintainers; [ manofthesea ];
    platforms = ["aarch64-linux"];
  };
}
