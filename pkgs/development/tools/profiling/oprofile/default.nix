{ stdenv, fetchurl, binutils, popt
, makeWrapper, gawk, which, gnugrep }:

stdenv.mkDerivation rec {
  name = "oprofile-0.9.3";

  src = fetchurl {
    url = "mirror://sourceforge/oprofile/${name}.tar.gz";
    sha256 = "1jxj8h11rwaviy5dz2ra7q41qfgdl1psc4470327pk5bblbap1jg";
  };

  patches = [ ./opcontrol.patch ];

  # FIXME: Add optional Qt support.
  buildInputs = [ binutils popt makeWrapper gawk which gnugrep ];

  configureFlags = "--with-kernel-support";

  postInstall = ''
    wrapProgram "$out/bin/opcontrol"					\
       --prefix PATH : "${gawk}/bin:${which}/bin:${gnugrep}/bin"
  '';

  meta = {
    description = "Oprofile, a system-wide profiler for Linux";
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
  };
}