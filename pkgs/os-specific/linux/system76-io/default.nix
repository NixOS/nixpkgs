{ lib, stdenv, fetchFromGitHub, kernel, fetchpatch }:
let
  version = "1.0.1";
  sha256 = "0qkgkkjy1isv6ws6hrcal75dxjz98rpnvqbm7agdcc6yv0c17wwh";
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

  patches = [
    (fetchpatch {
      name = "Fix_GCC_declaration-after-statement_error.patch";
      url = "https://patch-diff.githubusercontent.com/raw/pop-os/system76-io-dkms/pull/5.patch";
      sha256 = "sha256-G8SM5tdNbeLuwigmo1HKLN9o16WPpowLXxfM7Xi4aRI=";
    })
    (fetchpatch {
      name = "Fix_GCC_unused-function_error.patch";
      url = "https://patch-diff.githubusercontent.com/raw/pop-os/system76-io-dkms/pull/6.patch";
      sha256 = "sha256-vCXEzszmXa+wmI84oR8WduN4WnLTZA3M4GX+Jc4p/5o=";
    })
  ];

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
    platforms = [ "i686-linux" "x86_64-linux" ];
    broken = versionOlder kernel.version "4.14";
    description = "DKMS module for controlling System76 I/O board";
    homepage = "https://github.com/pop-os/system76-io-dkms";
  };
}
