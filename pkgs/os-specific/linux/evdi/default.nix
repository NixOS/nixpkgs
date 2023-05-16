<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, kernel, libdrm, python3 }:
let
  python3WithLibs = python3.withPackages (ps: with ps; [
    pybind11
  ]);
in
stdenv.mkDerivation rec {
  pname = "evdi";
  version = "1.13.1";
=======
{ lib, stdenv, fetchFromGitHub, kernel, libdrm }:

stdenv.mkDerivation rec {
  pname = "evdi";
  version = "unstable-2022-10-13";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "DisplayLink";
    repo = pname;
<<<<<<< HEAD
    rev = "v${version}";
    hash = "sha256-Or4hhnFOtC8vmB4kFUHbFHn2wg/NsUMY3d2Tiea6YbY=";
=======
    rev = "bdc258b25df4d00f222fde0e3c5003bf88ef17b5";
    hash = "sha256-mt+vEp9FFf7smmE2PzuH/3EYl7h89RBN1zTVvv2qJ/o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-error -Wno-error=sign-compare";

  nativeBuildInputs = kernel.moduleBuildDependencies;

<<<<<<< HEAD
  buildInputs = [ kernel libdrm python3WithLibs ];
=======
  buildInputs = [ kernel libdrm ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

<<<<<<< HEAD
  patches = [
    ./0000-fix-drm-path.patch
  ];

  meta = with lib; {
    description = "Extensible Virtual Display Interface";
    maintainers = with maintainers; [ ];
=======
  meta = with lib; {
    description = "Extensible Virtual Display Interface";
    maintainers = with maintainers; [ eyjhb ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.linux;
    license = with licenses; [ lgpl21Only gpl2Only ];
    homepage = "https://www.displaylink.com/";
    broken = kernel.kernelOlder "4.19" || stdenv.isAarch64;
  };
}
