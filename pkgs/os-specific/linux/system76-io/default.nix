{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
}:
let
  version = "1.0.4";
  hash = "sha256-VE6sCehjXlRuOVcK4EN2H+FhaVaBi/jrAYx4TZjbreA=";
in
stdenv.mkDerivation {
  name = "system76-io-module-${version}-${kernel.version}";

  passthru.moduleName = "system76_io";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "system76-io-dkms";
    rev = version;
    inherit hash;
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildFlags = [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -D system76-io.ko $out/lib/modules/${kernel.modDirVersion}/misc/system76-io.ko
  '';

  meta = {
    maintainers = with lib.maintainers; [
      khumba
      ahoneybun
    ];
    license = lib.licenses.gpl2Plus;
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "aarch64-linux"
    ];
    broken = lib.versionOlder kernel.version "5.10";
    description = "DKMS module for controlling System76 Io board";
    homepage = "https://github.com/pop-os/system76-io-dkms";
  };
}
