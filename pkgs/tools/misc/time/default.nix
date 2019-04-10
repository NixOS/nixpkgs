{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "time-${version}";
  version = "1.9";

  src = fetchurl {
    url = "mirror://gnu/time/${name}.tar.gz";
    sha256 = "07jj7cz6lc13iqrpgn81ivqh8rkm73p4rnivwgrrshk23v4g1b7v";
  };

  meta = {
    description = "Tool that runs programs and summarizes the system resources they use";

    longDescription = ''
      The `time' command runs another program, then displays
      information about the resources used by that program, collected
      by the system while the program was running.  You can select
      which information is reported and the format in which it is
      shown, or have `time' save the information in a file instead of
      displaying it on the screen.

      The resources that `time' can report on fall into the general
      categories of time, memory, and I/O and IPC calls.  Some systems
      do not provide much information about program resource use;
      `time' reports unavailable information as zero values.
    '';

    license = stdenv.lib.licenses.gpl3Plus;
    homepage = https://www.gnu.org/software/time/;
    platforms = stdenv.lib.platforms.unix;
  };
}
