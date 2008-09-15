{ stdenv, fetchurl, binutils, popt
, makeWrapper, gawk, which, gnugrep }:

stdenv.mkDerivation rec {
  name = "oprofile-0.9.4";

  src = fetchurl {
    url = "mirror://sourceforge/oprofile/${name}.tar.gz";
    sha256 = "1pna65lpdxzbg4lcmpvayw1ibinbizrzwpdp0cq7vfinj0am456b";
  };

  patchPhase = ''
    sed -i "utils/opcontrol" \
        -e "s|OPCONTROL=.*$|OPCONTROL=\"$out/bin/opcontrol\"|g ;
            s|OPDIR=.*$|OPDIR=\"$out/bin\"|g ;
            s|^PATH=.*$||g"
  '';

  # FIXME: Add optional Qt support.
  buildInputs = [ binutils popt makeWrapper gawk which gnugrep ];

  configureFlags = "--with-kernel-support";

  postInstall = ''
    wrapProgram "$out/bin/opcontrol"					\
       --prefix PATH : "$out/bin:${gawk}/bin:${which}/bin:${gnugrep}/bin"
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