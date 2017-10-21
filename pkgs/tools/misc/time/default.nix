{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "time-1.7";

  src = fetchurl {
    url = mirror://gnu/time/time-1.7.tar.gz;
    sha256 = "0va9063fcn7xykv658v2s9gilj2fq4rcdxx2mn2mmy1v4ndafzp3";
  };

  patches = [ ./max-resident.patch ];

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

    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://www.gnu.org/software/time/;
    platforms = stdenv.lib.platforms.unix;
  };
}
