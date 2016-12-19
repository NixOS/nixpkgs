{ stdenv, fetchurl, guileSupport ? false, pkgconfig ? null , guile ? null }:

assert guileSupport -> ( pkgconfig != null && guile != null );

let
  version = "4.2.1";
in
stdenv.mkDerivation {
  name = "gnumake-${version}";

  src = fetchurl {
    url = "mirror://gnu/make/make-${version}.tar.bz2";
    sha256 = "12f5zzyq2w56g95nni65hc0g5p7154033y2f3qmjvd016szn5qnn";
  };

  patchFlags = "-p0";
  patches = [
    # Purity: don't look for library dependencies (of the form `-lfoo') in /lib
    # and /usr/lib. It's a stupid feature anyway. Likewise, when searching for
    # included Makefiles, don't look in /usr/include and friends.
    ./impure-dirs.patch
  ];

  buildInputs = stdenv.lib.optionals guileSupport [ guile pkgconfig ];

  configureFlags = stdenv.lib.optional guileSupport "--with-guile";

  outputs = [ "out" "doc" ];

  meta = with stdenv.lib; {
    homepage = http://www.gnu.org/software/make/;
    description = "A tool to control the generation of non-source files from sources";
    license = licenses.gpl3Plus;

    longDescription = ''
      Make is a tool which controls the generation of executables and
      other non-source files of a program from the program's source files.

      Make gets its knowledge of how to build your program from a file
      called the makefile, which lists each of the non-source files and
      how to compute it from other files. When you write a program, you
      should write a makefile for it, so that it is possible to use Make
      to build and install the program.
    '';

    platforms = platforms.all;
    maintainers = [ maintainers.vrthra ];
  };
}
