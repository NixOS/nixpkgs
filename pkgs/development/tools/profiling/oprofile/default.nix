{ lib, stdenv, buildPackages
, fetchurl, pkg-config
, libbfd, popt, zlib, linuxHeaders, libiberty_static
, withGUI ? false, qt4 ? null
}:

# libX11 is needed because the Qt build stuff automatically adds `-lX11'.
assert withGUI -> qt4 != null;

stdenv.mkDerivation rec {
  name = "oprofile-1.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/oprofile/${name}.tar.gz";
    sha256 = "04m46ni0ryk4sqmzd6mahwzp7iwhwqzfbmfi42fki261sycnz83v";
  };

  postPatch = ''
    substituteInPlace opjitconv/opjitconv.c \
      --replace "/bin/rm" "${buildPackages.coreutils}/bin/rm" \
      --replace "/bin/cp" "${buildPackages.coreutils}/bin/cp"
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libbfd zlib popt linuxHeaders libiberty_static ]
    ++ lib.optionals withGUI [ qt4 ];

  configureFlags = [
      "--with-kernel=${linuxHeaders}"
      "--disable-shared"   # needed because only the static libbfd is available
    ]
    ++ lib.optional withGUI "--with-qt-dir=${qt4} --enable-gui=qt4";

  meta = {
    description = "System-wide profiler for Linux";
    longDescription = ''
      OProfile is a system-wide profiler for Linux systems, capable of
      profiling all running code at low overhead.  It consists of a
      kernel driver and a daemon for collecting sample data, and
      several post-profiling tools for turning data into information.

      OProfile leverages the hardware performance counters of the CPU
      to enable profiling of a wide variety of interesting statistics,
      which can also be used for basic time-spent profiling. All code
      is profiled: hardware and software interrupt handlers, kernel
      modules, the kernel, shared libraries, and applications.
    '';
    license = lib.licenses.gpl2;
    homepage = "http://oprofile.sourceforge.net/";

    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
