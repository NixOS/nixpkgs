{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
}:
let
  version = "1.0.2";
  sha256 = "sha256-DWUjQmoojkzFv1p4Xyt0kOwwqQ216ocO5yR/ujhhMPA=";
in
stdenv.mkDerivation {
  name = "system76-io-module-${version}-${kernel.version}";

  passthru.moduleName = "system76_io";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "system76-io-dkms";
    rev = version;
    inherit sha256;
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildFlags = [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -D system76-io.ko $out/lib/modules/${kernel.modDirVersion}/misc/system76-io.ko
  '';

  meta = with lib; {
    maintainers = [ maintainers.khumba ];
    license = [ licenses.gpl2Plus ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    broken = versionOlder kernel.version "4.14";
    description = "DKMS module for controlling System76 I/O board";
    homepage = "https://github.com/pop-os/system76-io-dkms";
  };
}
