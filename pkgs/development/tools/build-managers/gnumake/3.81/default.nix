{stdenv, fetchurl}:

let version = "3.81"; in
stdenv.mkDerivation {
  name = "gnumake-${version}";

  src = fetchurl {
    url = "mirror://gnu/make/make-${version}.tar.bz2";
    md5 = "354853e0b2da90c527e35aabb8d6f1e6";
  };

  doCheck = true;

  patches =
    [
      # Provide nested log output for subsequent pretty-printing by
      # nix-log2xml.
      ./log-3.81.patch

      # Purity: don't look for library dependencies (of the form
      # `-lfoo') in /lib and /usr/lib.  It's a stupid feature anyway.
      # Likewise, when searching for included Makefiles, don't look in
      # /usr/include and friends.
      ./impure-dirs.patch
    ];
  patchFlags = "-p0";

  meta = {
    description = "GNU Make, a program controlling the generation of non-source files from sources";

    longDescription =
      '' Make is a tool which controls the generation of executables and
         other non-source files of a program from the program's source files.

         Make gets its knowledge of how to build your program from a file
         called the makefile, which lists each of the non-source files and
         how to compute it from other files. When you write a program, you
         should write a makefile for it, so that it is possible to use Make
         to build and install the program.
      '';

    homepage = http://www.gnu.org/software/make/;

    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
