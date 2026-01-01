{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dddvb";
<<<<<<< HEAD
  version = "0.9.40a";
=======
  version = "0.9.40";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "DigitalDevices";
    repo = "dddvb";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-HsTkOYNKxlJ0NaMO/o0irVDBWP8i7Z5Rm1FBflGbRCo=";
=======
    hash = "sha256-6FDvgmZ6KHydy5CfrI/nHhKAJeG1HQ/aRUojFDSEzQY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    sed -i '/depmod/d' Makefile
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  # package requires -Wno-format which collides with -Wformat-security
  env.NIX_CFLAGS_COMPILE = "-Wno-format-security";

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "MDIR=$(out)"
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/DigitalDevices/dddvb";
    description = "Device driver for all Digital Devices DVB demodulator and modulator cards";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    broken = lib.versionAtLeast kernel.version "6.15";
  };
})
