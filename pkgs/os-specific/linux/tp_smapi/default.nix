{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation rec {
  name = "tp_smapi-${version}-${kernel.version}";
  version = "0.44-unstable-2025-05-26";

  src = fetchFromGitHub {
    owner = "linux-thinkpad";
    repo = "tp_smapi";
    rev = "a6122c0840c36bf232250afd1da30aaedaf24910";
    hash = "sha256-4bVyhTVj29ni9hduN20+VEl5/N0BAoMNMBw+k4yl8Y0=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  makeFlags = [
    "KBASE=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
    "SHELL=${stdenv.shell}"
    "HDAPS=1"
  ];

  installPhase = ''
    install -v -D -m 644 thinkpad_ec.ko "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/firmware/thinkpad_ec.ko"
    install -v -D -m 644 tp_smapi.ko "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/firmware/tp_smapi.ko"
    install -v -D -m 644 hdaps.ko "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/firmware/hdapsd.ko"
  '';

  dontStrip = true;

  enableParallelBuilding = true;

  meta = {
    description = "IBM ThinkPad hardware functions driver";
    homepage = "https://github.com/linux-thinkpad/tp_smapi";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    # driver is only meant for linux thinkpads i think  bellow platforms should cover it.
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
