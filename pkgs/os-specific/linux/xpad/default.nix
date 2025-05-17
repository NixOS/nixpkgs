{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
}:
stdenv.mkDerivation rec {
  pname = "xpad-noone";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "medusalix";
    repo = pname;
    rev = "master";
    sha256 = "sha256-PCaXW55wKaOSXRUF/t1p1l8q43OQ6Fmj56ZjwdKcYiw=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  KDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  buildPhase = "make -C ${KDIR} M=/build/source modules";
  installPhase = ''
    make -C ${KDIR} M=/build/source INSTALL_MOD_PATH="$out" modules_install
  '';

  meta = with lib; {
    homepage = "https://github.com/medusalix/xpad-noone";
    downloadPage = "https://github.com/medusalix/xpad-noone";
    description = "Enables usage of older Xbox peripherals";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
