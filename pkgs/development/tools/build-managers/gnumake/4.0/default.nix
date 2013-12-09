{stdenv, fetchurl}:

let version = "4.0"; in
stdenv.mkDerivation {
  name = "gnumake-${version}";

  src = fetchurl {
    url = "mirror://gnu/make/make-${version}.tar.bz2";
    sha256 = "1nyvn8mknw0mf7727lprva3lisl1y0n03lvar342rrpdmz3qc1p6";
  };

  /* On Darwin, there are 3 test failures that haven't been investigated
     yet.  */
  doCheck = !stdenv.isDarwin && !stdenv.isFreeBSD;

  patches =
    [
      # Purity: don't look for library dependencies (of the form
      # `-lfoo') in /lib and /usr/lib.  It's a stupid feature anyway.
      # Likewise, when searching for included Makefiles, don't look in
      # /usr/include and friends.
      ./impure-dirs.patch

      # a bunch of patches from Gentoo, mostly should be from upstream (unreleased)
      ./darwin-library_search-dylib.patch
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

    license = "GPLv3+";
    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}
