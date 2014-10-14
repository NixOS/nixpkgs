{ stdenv, fetchgit, kernel }:

assert stdenv.lib.versionAtLeast kernel.version "3.4";  # fails on 3.2

stdenv.mkDerivation rec {
  pname = "lttng-modules-${version}";
  name = "${pname}-${kernel.version}";
  # Support for linux 3.16 and 3.17 was added just after the 2.5.0 release
  version = "2.5.0-58-gbf2ba31"; # "git describe bf2ba318fff"

  src = fetchgit {
    url = "https://github.com/lttng/lttng-modules.git";
    sha256 = "0x70xp463g208rdz5b9b0wdwr2v8px1bwa589knvp4j7zi8d2gj9";
    rev = "bf2ba318fff";
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
    # TODO license = with licenses; [ lgpl21 gpl2 mit ];
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
