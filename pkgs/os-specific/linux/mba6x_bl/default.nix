{
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  lib,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "mba6x_bl";
  version = "unstable-2017-12-30";

  src = fetchFromGitHub {
    owner = "patjak";
    repo = "mba6x_bl";
    rev = "639719f516b664051929c2c0c1140ea4bf30ce81";
    sha256 = "sha256-QwxBpNa5FitKO+2ne54IIcRgwVYeNSQWI4f2hPPB8ls=";
  };

  enableParallelBuilding = true;
  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  meta = {
    description = "MacBook Air 6,1 and 6,2 (mid 2013) backlight driver";
    homepage = "https://github.com/patjak/mba6x_bl";
    license = lib.licenses.gpl2Only;
    # This out-of-tree module calls acpi_video_set_dmi_backlight_type(), which
    # was removed from the kernel in 6.1, so it fails to build (the kernel uses
    # -Werror=implicit-function-declaration). Upstream is unmaintained since 2017.
    # API removal: https://github.com/torvalds/linux/commit/77ab9d4d44cd235322d2f30b1c4026302c3ce8c6
    broken = kernel.kernelAtLeast "6.1";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.simonvandel ];
  };
}
