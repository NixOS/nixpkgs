{ stdenv, fetchurl, kernel }:

assert stdenv.lib.versionAtLeast kernel.version "3.4";  # fails on 3.2
assert builtins.substring 0 4 kernel.version != "3.12";

stdenv.mkDerivation rec {
  pname = "lttng-modules-${version}";
  name = "${pname}-${kernel.version}";
  version = "2.6.0-rc1"; # "git describe bf2ba318fff"

  src = fetchurl {
    url = "https://github.com/lttng/lttng-modules/archive/v${version}.tar.gz";
    sha256 = "01gha02ybbzr86v6s6bqn649jiw5k89kb363b9s1iv8igrdlzhl1";
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
