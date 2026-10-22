{
  lib,
  stdenv,
  fetchFromGitLab,
  kernel,
  kernelModuleHook,
}:

stdenv.mkDerivation rec {
  pname = "ddcci-driver";
  version = "0.4.5-unstable-2025-09-27";
  name = "${pname}-${kernel.version}-${version}";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitLab {
    owner = "${pname}-linux";
    repo = "${pname}-linux";
    rev = "bbb7553373f815d78e93a4a9f071ce968563694a";
    hash = "sha256-fQjsDjbtFKhs0bUCFfKRgCg516TXdwIkhKEbIISjgs0=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [ kernelModuleHook ];

  patches = [
    ./0001-Use-sysfs_emit-and-field-width-specifier.patch
  ];

  kbuildDirectories = [
    "ddcci"
    "ddcci-backlight"
  ];

  meta = {
    description = "Kernel module driver for DDC/CI monitors";
    homepage = "https://gitlab.com/ddcci-driver-linux/ddcci-driver-linux";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ kiike ];
    platforms = lib.platforms.linux;
    broken = kernel.kernelOlder "5.1";
  };
}
