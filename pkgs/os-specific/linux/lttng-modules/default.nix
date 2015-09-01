{ stdenv, fetchFromGitHub, kernel }:

assert stdenv.lib.versionAtLeast kernel.version "3.4";  # fails on 3.2

stdenv.mkDerivation rec {
  pname = "lttng-modules-${version}";
  name = "${pname}-${kernel.version}";
  version = "2.6.2-1-g7a88f8b";

  src = fetchFromGitHub {
    owner = "lttng";
    repo = "lttng-modules";
    rev = "7a88f8b50696dd71e80c08661159caf8e119bf51";
    sha256 = "1i185dvk4wn7fmmx1zfv6g15x8wi38jmav2dmq0mmy8cvriajq8h";
  };

  preConfigure = ''
    export KERNELDIR="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    export INSTALL_MOD_PATH="$out"
  '';

  installPhase = ''
    make modules_install
  '';

  meta = with stdenv.lib; {
    description = "Linux kernel modules for LTTng tracing";
    homepage = http://lttng.org/;
    license = with licenses; [ lgpl21 gpl2 mit ];
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
