{ lib, stdenv, fetchFromGitHub, fetchpatch, kernel, libdrm }:

stdenv.mkDerivation rec {
  pname = "evdi";
  version = "unstable-2021-06-11";

  src = fetchFromGitHub {
    owner = "DisplayLink";
    repo = pname;
    rev = "65e12fca334f2f42396f4e8d16592d53cab34dd6";
    sha256 = "sha256-81IfdYKadKT7vRdkmxzfGo4KHa4UJ8uJ0K6djQCr22U=";
  };

  # Linux 5.13 support
  # The patches break compilation for older kernels
  patches = lib.optional (kernel.kernelAtLeast "5.13") [
    (fetchpatch {
      url = "https://github.com/DisplayLink/evdi/commit/c5f5441d0a115d2cfc8125b8bafaa05b2edc7938.patch";
      sha256 = "sha256-tWYgBrRh3mXPebhUygOvJ07V87g9JU66hREriACfEVI=";
    })
    (fetchpatch {
      url = "https://github.com/DisplayLink/evdi/commit/5f04d2e2df4cfd21dc15d31f1152c6a66fa48a78.patch";
      sha256 = "sha256-690/eUiEVWvnT/YAVgKcLo86dgolF9giWRuPxXpL+eQ=";
    })
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildInputs = [ kernel libdrm ];

  makeFlags = [
    "KVER=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  hardeningDisable = [ "format" "pic" "fortify" ];

  installPhase = ''
    install -Dm755 module/evdi.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/gpu/drm/evdi/evdi.ko
    install -Dm755 library/libevdi.so $out/lib/libevdi.so
  '';

  meta = with lib; {
    description = "Extensible Virtual Display Interface";
    maintainers = with maintainers; [ eyjhb ];
    platforms = platforms.linux;
    license = with licenses; [ lgpl21Only gpl2Only ];
    homepage = "https://www.displaylink.com/";
    broken = kernel.kernelOlder "4.19" || stdenv.isAarch64;
  };
}
