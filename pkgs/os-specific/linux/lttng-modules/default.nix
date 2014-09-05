{ stdenv, fetchurl, kernel }:

stdenv.mkDerivation rec {
  pname = "lttng-modules-2.4.1";
  name = "${pname}-${kernel.version}";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-modules/${pname}.tar.bz2";
    sha256 = "1qn1qm8lwqw9ri9wfkf6k3d58gl9rwffmpbpkwx21v1fw95zi92k";
  };

  patches = [ ./lttng-fix-build-error-on-linux-3.2.patch ];

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
    # TODO license = with licenses; [ lgpl21 gpl2 mit ];
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
    broken = true;
  };

}
