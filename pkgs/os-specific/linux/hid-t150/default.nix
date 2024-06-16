{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation {
  pname = "hid-t150";
  #https://github.com/scarburato/t150_driver/blob/165d0601e11576186c9416c40144927549ef804d/install.sh#L3
  version = "0.8a";

  src = fetchFromGitHub {
    owner = "scarburato";
    repo = "t150_driver";
    rev = "580b79b7b479076ba470fcc21fbd8484f5328546";
    hash = "sha256-6xqm8500+yMXA/WonMv1JAOS/oIeSNDp9HFuYkEd03U=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  sourceRoot = "source/hid-t150";

  makeFlags = kernel.makeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  installPhase = ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$(pwd) modules_install $makeFlags
  '';

  meta = with lib; {
    description = "A linux kernel driver for Thrustmaster T150 and TMX Force Feedback wheel";
    homepage = "https://github.com/scarburato/t150_driver";
    license = licenses.gpl2;
    maintainers = [ maintainers.dbalan ];
    platforms = platforms.linux;
  };
}
