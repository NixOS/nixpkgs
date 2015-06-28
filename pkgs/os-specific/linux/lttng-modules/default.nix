{ stdenv, fetchgit, kernel }:

assert stdenv.lib.versionAtLeast kernel.version "3.4";  # fails on 3.2

stdenv.mkDerivation rec {
  pname = "lttng-modules-${version}";
  name = "${pname}-${kernel.version}";
  version = "2.6.0-5-g1b2a542";

  src = fetchgit {
    url = "https://github.com/lttng/lttng-modules.git";
    rev = "1b2a5429de815c95643df2eadf91253909708728";
    sha256 = "0zccaiadnk0xl6xrqaqlg9rpkwjgbq2fiyc3psylzqimnx0ydxc2";
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
