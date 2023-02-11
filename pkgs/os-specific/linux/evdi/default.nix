{ lib, stdenv, fetchFromGitHub, kernel, libdrm }:

stdenv.mkDerivation rec {
  pname = "evdi";
  version = "unstable-2022-10-13";

  src = fetchFromGitHub {
    owner = "DisplayLink";
    repo = pname;
    rev = "bdc258b25df4d00f222fde0e3c5003bf88ef17b5";
    hash = "sha256-mt+vEp9FFf7smmE2PzuH/3EYl7h89RBN1zTVvv2qJ/o=";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error -Wno-error=sign-compare";

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildInputs = [ kernel libdrm ];

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
    description = "Extensible Virtual Display Interface";
    maintainers = with maintainers; [ eyjhb ];
    platforms = platforms.linux;
    license = with licenses; [ lgpl21Only gpl2Only ];
    homepage = "https://www.displaylink.com/";
    broken = kernel.kernelOlder "4.19" || stdenv.isAarch64;
  };
}
