{ lib, fetchFromGitHub, kernel, buildModule }:
let
  version = "1.0.1";
  sha256 = "0qkgkkjy1isv6ws6hrcal75dxjz98rpnvqbm7agdcc6yv0c17wwh";
in
buildModule {
  pname = "system76-io-module";
  inherit version;

  passthru.moduleName = "system76_io";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "system76-io-dkms";
    rev = version;
    inherit sha256;
  };

  hardeningDisable = [ "pic" ];

  buildFlags = [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -D system76-io.ko $out/lib/modules/${kernel.modDirVersion}/misc/system76-io.ko
  '';

  overridePlatforms = [ "i686-linux" "x86_64-linux" ];

  meta = with lib; {
    maintainers = [ maintainers.khumba ];
    license = [ licenses.gpl2Plus ];
    broken = versionOlder kernel.version "4.14";
    description = "DKMS module for controlling System76 I/O board";
    homepage = "https://github.com/pop-os/system76-io-dkms";
  };
}
