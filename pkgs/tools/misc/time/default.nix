{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "time-${version}";
  version = "1.8";

  src = fetchurl {
    url = "mirror://gnu/time/${name}.tar.gz";
    sha256 = "06rfg8dn0q2r8pdq8i6brrs6rqrsgvkwbbl4kfx3a6lnal0m8bwa";
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
    homepage = http://www.gnu.org/software/time/;
    platforms = stdenv.lib.platforms.unix;
  };
}
