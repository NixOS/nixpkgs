{ stdenv, fetchurl, gnutar, gzip, gnumake, coreutils, gawk, gnused, gnugrep, bash, clang, which}:
stdenv.mkDerivation {
  name = "wfdb";
  builder = "${bash}/bin/bash";
  args = [ ./builder.sh ];
  gcc = clang;
  binutils = clang.bintools.bintools_bin;
  buildInputs = [ gnutar gzip gnumake coreutils gawk gnused gnugrep which clang clang.bintools.bintools_bin ];
  src = fetchurl{
        url = https://archive.physionet.org/physiotools/wfdb.tar.gz;
        sha256 = "6a76da12746a51bfcd1a87461c9578b6eef741933c83d7a5e5b16f605b44afdc";
  };
  system = builtins.currentSystem;
  meta = with stdenv.lib; {
  description = "A library for reading and writing files in the formats used by PhysioBank databases";
  longDescription = ''
    This is a set of functions (subroutines) for reading and writing files in the formats used by PhysioBank databases (among others). The WFDB library is LGPLed, and can be used by programs written in ANSI/ISO C, K&R C, C++, or Fortran, running under any operating system for which an ANSI/ISO or K&R C compiler is available, including all versions of Unix, MS-DOS, MS-Windows, the Macintosh OS, and VMS.
  '';
  homepage = https://archive.physionet.org/physiotools/wfdb.shtml;
  license = licenses.lgpl2;
  maintainers = [ maintainers.maksteel ];
  platforms = platforms.all;
};
}
