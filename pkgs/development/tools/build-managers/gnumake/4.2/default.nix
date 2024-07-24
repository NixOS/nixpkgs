{ lib, stdenv, fetchurl, guileSupport ? false, pkg-config ? null , guile ? null }:

assert guileSupport -> ( pkg-config != null && guile != null );

stdenv.mkDerivation rec {
  pname = "gnumake";
  version = "4.2.1";

  src = fetchurl {
    url = "mirror://gnu/make/make-${version}.tar.bz2";
    sha256 = "12f5zzyq2w56g95nni65hc0g5p7154033y2f3qmjvd016szn5qnn";
  };

  patchFlags = [ "-p0" ];
  patches = [
    # Purity: don't look for library dependencies (of the form `-lfoo') in /lib
    # and /usr/lib. It's a stupid feature anyway. Likewise, when searching for
    # included Makefiles, don't look in /usr/include and friends.
    ./impure-dirs.patch
    ./pselect.patch
    # Fix support for glibc 2.27's glob, inspired by http://www.linuxfromscratch.org/lfs/view/8.2/chapter05/make.html
    ./glibc-2.27-glob.patch
    ./glibc-2.33-glob.patch
  ];

  nativeBuildInputs = lib.optionals guileSupport [ pkg-config ];
  buildInputs = lib.optionals guileSupport [ guile ];

  configureFlags = lib.optional guileSupport "--with-guile"

    # Make uses this test to decide whether it should keep track of
    # subseconds. Apple made this possible with APFS and macOS 10.13.
    # However, we still support macOS 10.11 and 10.12. Binaries built
    # in Nixpkgs will be unable to use futimens to set mtime less than
    # a second. So, tell Make to ignore nanoseconds in mtime here by
    # overriding the autoconf test for the struct.
    # See https://github.com/NixOS/nixpkgs/issues/51221 for discussion.
    ++ lib.optional stdenv.isDarwin "ac_cv_struct_st_mtim_nsec=no";

  outputs = [ "out" "man" "info" ];

  meta = with lib; {
    description = "Tool to control the generation of non-source files from sources";
    longDescription = ''
      Make is a tool which controls the generation of executables and
      other non-source files of a program from the program's source files.

      Make gets its knowledge of how to build your program from a file
      called the makefile, which lists each of the non-source files and
      how to compute it from other files. When you write a program, you
      should write a makefile for it, so that it is possible to use Make
      to build and install the program.
    '';
    homepage = "https://www.gnu.org/software/make/";

    license = licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "make";
    platforms = platforms.all;
  };
}
