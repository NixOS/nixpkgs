{ lib, stdenv, kernel, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "can-isotp";
  version = "20200910";

  hardeningDisable = [ "pic" ];

  src = fetchFromGitHub {
    owner = "hartkopp";
    repo = "can-isotp";
    rev = "21a3a59e2bfad246782896841e7af042382fcae7";
    sha256 = "1laax93czalclg7cy9iq1r7hfh9jigh7igj06y9lski75ap2vhfq";
  };

  makeFlags = kernel.makeFlags ++ [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  buildFlags = [ "modules" ];
  installTargets = [ "modules_install" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  meta = with lib; {
    broken = kernel.kernelAtLeast "5.16";
    description = "Kernel module for ISO-TP (ISO 15765-2)";
    homepage = "https://github.com/hartkopp/can-isotp";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.evck ];
  };
}
