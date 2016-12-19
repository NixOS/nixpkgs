{ stdenv, fetchurl, kernel }:

stdenv.mkDerivation rec {
  pname = "lttng-modules-${version}";
  name = "${pname}-${kernel.version}";
  version = "2.8.3";

  src = fetchurl {
    url = "http://lttng.org/files/lttng-modules/lttng-modules-${version}.tar.bz2";
    sha256 = "018lqxbksj9hpjfp2a3yc6lkjkj4rgf2x147l1jjh7mfgqvcb53b";
  };

  hardeningDisable = [ "pic" ];

  NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

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
    broken =
      (builtins.compareVersions kernel.version "3.18" == -1) ||
      (kernel.features.grsecurity or false) ||
      (kernel.features.chromiumos or false);
  };

}
