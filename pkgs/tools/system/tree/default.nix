{stdenv, fetchurl}:

let
  version = "1.7.0";

  # These settings are found in the Makefile, but there seems to be no
  # way to select one ore the other setting other than editing the file
  # manually, so we have to duplicate the know how here.
  systemFlags =
    if stdenv.isDarwin then ''
      CFLAGS="-O2 -Wall -fomit-frame-pointer"
      LDFLAGS=
      EXTRA_OBJS=strverscmp.o
    '' else if stdenv.isCygwin then ''
      CFLAGS="-O2 -Wall -fomit-frame-pointer -DCYGWIN"
      LDFLAGS=-s
      TREE_DEST=tree.exe
      EXTRA_OBJS=strverscmp.o
    '' else if stdenv.isBSD then ''
      CFLAGS="-O2 -Wall -fomit-frame-pointer"
      LDFLAGS=-s
      EXTRA_OBJS=strverscmp.o
    '' else
    ""; # use linux flags by default
in
stdenv.mkDerivation {
  name = "tree-${version}";

  src = fetchurl {
    url = "http://mama.indstate.edu/users/ice/tree/src/tree-${version}.tgz";
    sha256 = "04kviw799qxly08zb8n5mgxfd96gyis6x69q2qiw86jnh87c4mv9";
  };

  configurePhase = ''
    sed -i Makefile -e 's|^OBJS=|OBJS=$(EXTRA_OBJS) |'
    makeFlagsArray=(
      prefix=$out
      MANDIR=$out/share/man/man1
      ${systemFlags}
    )
  '';

  meta = {
    homepage = "http://mama.indstate.edu/users/ice/tree/";
    description = "command to produce a depth indented directory listing";
    license = stdenv.lib.licenses.gpl2;

    longDescription = ''
      Tree is a recursive directory listing command that produces a
      depth indented listing of files, which is colorized ala dircolors if
      the LS_COLORS environment variable is set and output is to tty.
    '';

    platforms = stdenv.lib.platforms.all;
    maintainers = [stdenv.lib.maintainers.simons];
  };
}
