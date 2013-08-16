{ stdenv, fetchurl, kernelDev }:

stdenv.mkDerivation rec {
  pname = "lttng-modules-2.2.1";
  name = "${pname}-${kernelDev.version}";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-modules/${pname}.tar.bz2";
    sha256 = "00ww1443ssv614s1ix6zby8llaf6zzlxcf5k4w7jsyji47ng33m2";
  };

  patches = [ ./lttng-fix-build-error-on-linux-3.2.patch ];

  preConfigure = ''
    export KERNELDIR="${kernelDev}/lib/modules/${kernelDev.modDirVersion}/build"
    export INSTALL_MOD_PATH="$out"
  '';

  installPhase = ''
    make modules_install
  '';

  meta = with stdenv.lib; {
    description = "Linux kernel modules for LTTng tracing";
    homepage = http://lttng.org/;
    # TODO: Add "mit" to the license list once the license attr set vs string
    # decision has been made. (Having "mit" there breaks hydra evaluation.)
    license = with licenses; [ lgpl21 gpl2 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
