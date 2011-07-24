{stdenv, fetchurl}:

let
  version = "1.6.0";

  # These settings are found in the Makefile, but there seems to be no
  # way to select one ore the other setting other than editing the file
  # manually, so we have to duplicate the know how here.
  systemFlags =
    if stdenv.isDarwin then ''
      CFLAGS="-O2 -Wall -fomit-frame-pointer -no-cpp-precomp"
      LDFLAGS=
      OBJS+=strverscmp.o
    '' else
    "";
in
stdenv.mkDerivation {
  name = "tree-${version}";

  src = fetchurl {
    url = "http://mama.indstate.edu/users/ice/tree/src/tree-${version}.tgz";
    sha256 = "4dc470a74880338b01da41701d8db90d0fb178877e526d385931a007d68d7591";
  };

  configurePhase = ''
    makeFlagsArray=(
      prefix=$out
      MANDIR=$out/share/man/man1
      ${systemFlags}
    )
  '';

  meta = {
    homepage = "http://mama.indstate.edu/users/ice/tree/";
    description = "command to produce a depth indented directory listing";
    license = "GPLv2";

    longDescription = ''
      Tree is a recursive directory listing command that produces a
      depth indented listing of files, which is colorized ala dircolors if
      the LS_COLORS environment variable is set and output is to tty.
    '';

    platforms = stdenv.lib.platforms.all;
    maintainers = [stdenv.lib.maintainers.simons];
  };
}
