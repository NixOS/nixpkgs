{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dddvb";
  version = "0.9.40a";

  src = fetchFromGitHub {
    owner = "DigitalDevices";
    repo = "dddvb";
    tag = finalAttrs.version;
    hash = "sha256-HsTkOYNKxlJ0NaMO/o0irVDBWP8i7Z5Rm1FBflGbRCo=";
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
