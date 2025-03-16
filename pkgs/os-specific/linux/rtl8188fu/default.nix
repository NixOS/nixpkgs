{ stdenv, lib, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  name = "rtl8188fu-${kernel.version}-${version}";
  version = "2022-06-11";

  src = fetchFromGitHub ({
    owner = "kelebek333";
    repo = "rtl8188fu";
  } // (if stdenv.targetPlatform.isAarch32 || stdenv.targetPlatform.isAarch64 then {
    rev = "31448865d3a262971e571e3ee1d4d78b4438dfa8";
    sha256 = "sha256-5k0iDGj+K2ctI2G3SmGzjDk+E8ZpONP2A3G1ScvNx9s=";
  } else {
    rev = "dfe0a5090a1ec593ba558b589f092cce29e6256f";
    sha256 = "sha256-ZUoNXD1ATEHTrHwW7EBLk7I7gASGv9U/GAYSjBvrQoU=";
  }));

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -D rtl8188fu.ko -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless
    install -D firmware/rtl8188fufw.bin -t $out/lib/firmware/rtlwifi
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Driver for Realtek rtl8188fu";
    homepage = "https://github.com/kelebek333/rtl8188fu";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ puffnfresh ];
  };
}
