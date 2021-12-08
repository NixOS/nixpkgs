{ lib, stdenv, kernel, fetchFromGitHub, buildModule }:

buildModule {
  pname = "can-isotp";
  version = "20200910";

  hardeningDisable = [ "pic" ];

  src = fetchFromGitHub {
    owner = "hartkopp";
    repo = "can-isotp";
    rev = "21a3a59e2bfad246782896841e7af042382fcae7";
    sha256 = "1laax93czalclg7cy9iq1r7hfh9jigh7igj06y9lski75ap2vhfq";
  };


  buildPhase = ''
    export KERNELDIR="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
    make modules
  '';

  installPhase = (''
    export INSTALL_MOD_PATH="\$'' +
    ''{out}"
    make modules_install
  '');

  meta = with lib; {
    description = "Kernel module for ISO-TP (ISO 15765-2)";
    homepage = "https://github.com/hartkopp/can-isotp";
    license = licenses.gpl2;
    maintainers = [ maintainers.evck ];
  };
}
