{ stdenv, fetchurl, binutils, popt, makeWrapper, gawk, which, gnugrep
, qt ? null, libX11 ? null, libXext ? null, libpng ? null }:

# libX11 is needed because the Qt build stuff automatically adds `-lX11'.
assert (qt != null) -> ((libX11 != null) && (libXext != null)
                        && (libpng != null));

stdenv.mkDerivation rec {
  name = "oprofile-0.9.6";

  src = fetchurl {
    url = "mirror://sourceforge/oprofile/${name}.tar.gz";
    sha256 = "103q0w4wr5lnhg1yfdhc67dvdwzqpzml57fp4l6nbz29fw5d839z";
  };

  patchPhase = ''
    sed -i "utils/opcontrol" \
        -e "s|OPCONTROL=.*$|OPCONTROL=\"$out/bin/opcontrol\"|g ;
            s|OPDIR=.*$|OPDIR=\"$out/bin\"|g ;
            s|^PATH=.*$||g"
  '';

  buildInputs = [ binutils popt makeWrapper gawk which gnugrep ]
    ++ stdenv.lib.optionals (qt != null) [ qt libX11 libXext libpng ];

  configureFlags =
    [ "--with-kernel-support"
      "--disable-shared"   # needed because only the static libbfd is available
    ]
    ++ stdenv.lib.optional (qt != null) "--with-qt-dir=${qt}";

  postInstall = ''
    wrapProgram "$out/bin/opcontrol"					\
       --prefix PATH : "$out/bin:${gawk}/bin:${which}/bin:${gnugrep}/bin"
  '';

  meta = {
    description = "OProfile, a system-wide profiler for Linux";
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
    license = "GPLv2";
    homepage = http://oprofile.sourceforge.net/;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
