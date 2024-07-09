{ lib
, stdenv
, fetchurl
, updateAutotoolsGnuConfigScriptsHook
, guileSupport ? false, guile
# avoid guile depend on bootstrap to prevent dependency cycles
, inBootstrap ? false
, pkg-config
, gnumake
}:

let
  guileEnabled = guileSupport && !inBootstrap;
in

stdenv.mkDerivation rec {
  pname = "gnumake";
  version = "4.4.1";

  src = fetchurl {
    url = "mirror://gnu/make/make-${version}.tar.gz";
    sha256 = "sha256-3Rb7HWe/q3mnL16DkHNcSePo5wtJRaFasfgd23hlj7M=";
  };

  # to update apply these patches with `git am *.patch` to https://git.savannah.gnu.org/git/make.git
  patches = [
    # Replaces /bin/sh with sh, see patch file for reasoning
    ./0001-No-impure-bin-sh.patch
    # Purity: don't look for library dependencies (of the form `-lfoo') in /lib
    # and /usr/lib. It's a stupid feature anyway. Likewise, when searching for
    # included Makefiles, don't look in /usr/include and friends.
    ./0002-remove-impure-dirs.patch
  ];

  nativeBuildInputs = [ updateAutotoolsGnuConfigScriptsHook ] ++ lib.optionals guileEnabled [ pkg-config ];
  buildInputs = lib.optionals guileEnabled [ guile ];

  configureFlags = lib.optional guileEnabled "--with-guile"

    # Make uses this test to decide whether it should keep track of
    # subseconds. Apple made this possible with APFS and macOS 10.13.
    # However, we still support macOS 10.11 and 10.12. Binaries built
    # in Nixpkgs will be unable to use futimens to set mtime less than
    # a second. So, tell Make to ignore nanoseconds in mtime here by
    # overriding the autoconf test for the struct.
    # See https://github.com/NixOS/nixpkgs/issues/51221 for discussion.
    ++ lib.optional stdenv.isDarwin "ac_cv_struct_st_mtim_nsec=no";

  outputs = [ "out" "man" "info" ];
  separateDebugInfo = true;

  passthru.tests = {
    # make sure that the override doesn't break bootstrapping
    gnumakeWithGuile = gnumake.override { guileSupport = true; };
  };

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
    maintainers = [ maintainers.vrthra ];
    mainProgram = "make";
    platforms = platforms.all;
  };
}
