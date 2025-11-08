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

  meta = with lib; {
    description = "MacBook Air 6,1 and 6,2 (mid 2013) backlight driver";
    homepage = "https://github.com/patjak/mba6x_bl";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.simonvandel ];
  };
}
