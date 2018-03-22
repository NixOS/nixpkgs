{ stdenv, fetchurl, texinfo, guileSupport ? false, pkgconfig , guile ? null, autoreconfHook }:

assert guileSupport -> ( guile != null );

let
  version = "4.2.90";
  revision = "48c8a116a914a325a0497721f5d8b58d5bba34d4";
  revCount = "2491";
  shortRev = "48c8a11";

  baseVersion = "4.2.1";
  baseTarball = fetchurl {
    url = "mirror://gnu/make/make-${baseVersion}.tar.bz2";
    sha256 = "12f5zzyq2w56g95nni65hc0g5p7154033y2f3qmjvd016szn5qnn";
  };
in
stdenv.mkDerivation {
  name = "gnumake-${version}pre${revCount}_${shortRev}";

  src = fetchurl {
    url = "http://git.savannah.gnu.org/cgit/make.git/snapshot/make-${revision}.tar.gz";
    sha256 = "0k6yvhr2a5lh1qhflv02dyvq5p20ikgaakm8w6gr4xmkspljwpwx";
  };

  postUnpack = ''
    unpackFile ${baseTarball}
    cp make-${baseVersion}/po/*.po $sourceRoot/po
    cp make-${baseVersion}/doc/{fdl,make-stds}.texi $sourceRoot/doc
  '';

  patches = [
    # Purity: don't look for library dependencies (of the form `-lfoo') in /lib
    # and /usr/lib. It's a stupid feature anyway. Likewise, when searching for
    # included Makefiles, don't look in /usr/include and friends.
    ./impure-dirs-head.patch
  ];

  postPatch = ''
    # These aren't in the 4.2.1 tarball yet.
    sed -i -e 's/sr//' -e 's/zh_TW//' po/LINGUAS
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig texinfo ];
  buildInputs = stdenv.lib.optional guileSupport guile;

  configureFlags = stdenv.lib.optional guileSupport "--with-guile";

  outputs = [ "out" "man" "info" ];

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
