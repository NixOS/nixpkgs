{ stdenv, kernel, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "can-isotp";
  version = "20180629";

  hardeningDisable = [ "pic" ];
  
  src = fetchFromGitHub {
    owner = "hartkopp";
    repo = "can-isotp";
    rev = "6003f9997587e6a563cebf1f246bcd0eb6deff3d";
    sha256 = "0b2pqb0vd1wgv2zpl7lvfavqkzr8mrwhrv7zdqkq3rz9givcv8w7";
  };

  KERNELDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  INSTALL_MOD_PATH = "\${out}";

  buildPhase = ''
    make modules
  '';

  installPhase = ''
    make modules_install
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;
  
  meta = with stdenv.lib; {
    description = "Kernel module for ISO-TP (ISO 15765-2)";
    homepage = "https://github.com/hartkopp/can-isotp";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.evck ];
  };
}  
