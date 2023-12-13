{ lib, stdenv, fetchFromGitHub, kernel, libdrm, python3 }:

let
  python3WithLibs = python3.withPackages (ps: with ps; [
    pybind11
  ]);
in
stdenv.mkDerivation rec {
  pname = "evdi";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "DisplayLink";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-em3Y56saB7K3Wr31Y0boc38xGb57gdveN0Cstgy8y20=";
  };

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error"
    "-Wno-error=discarded-qualifiers" # for Linux 4.19 compatibility
    "-Wno-error=sign-compare"
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildInputs = [ kernel libdrm python3WithLibs ];

  makeFlags = kernel.makeFlags ++ [
    "KVER=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  hardeningDisable = [ "format" "pic" "fortify" ];

  installPhase = ''
    install -Dm755 module/evdi.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/gpu/drm/evdi/evdi.ko
    install -Dm755 library/libevdi.so $out/lib/libevdi.so
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    changelog = "https://github.com/DisplayLink/evdi/releases/tag/v${version}";
    description = "Extensible Virtual Display Interface";
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    license = with licenses; [ lgpl21Only gpl2Only ];
    homepage = "https://www.displaylink.com/";
    broken = kernel.kernelOlder "4.19" || kernel.kernelAtLeast "6.6";
  };
}
