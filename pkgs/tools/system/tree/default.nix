{ lib, stdenv, fetchurl }:

let
  version = "1.8.0";

  # These settings are found in the Makefile, but there seems to be no
  # way to select one ore the other setting other than editing the file
  # manually, so we have to duplicate the know how here.
  systemFlags = with stdenv;
    if isDarwin then ''
      CFLAGS="-O2 -Wall -fomit-frame-pointer"
      LDFLAGS=
      EXTRA_OBJS=strverscmp.o
    '' else if isCygwin then ''
      CFLAGS="-O2 -Wall -fomit-frame-pointer -DCYGWIN"
      LDFLAGS=-s
      TREE_DEST=tree.exe
      EXTRA_OBJS=strverscmp.o
    '' else if (isFreeBSD || isOpenBSD) then ''
      CFLAGS="-O2 -Wall -fomit-frame-pointer"
      LDFLAGS=-s
      EXTRA_OBJS=strverscmp.o
    '' else
    ""; # use linux flags by default
in
stdenv.mkDerivation {
  pname = "tree";
  inherit version;

  src = fetchurl {
    url = "http://mama.indstate.edu/users/ice/tree/src/tree-${version}.tgz";
    sha256 = "1hmpz6k0mr6salv0nprvm1g0rdjva1kx03bdf1scw8a38d5mspbi";
  };

  configurePhase = ''
    sed -i Makefile -e 's|^OBJS=|OBJS=$(EXTRA_OBJS) |'
    makeFlagsArray=(
      prefix=$out
      MANDIR=$out/share/man/man1
      ${systemFlags}
      CC="$CC"
    )
  '';

  meta = {
    homepage = "http://mama.indstate.edu/users/ice/tree/";
    description = "Command to produce a depth indented directory listing";
    license = lib.licenses.gpl2;

    longDescription = ''
      Tree is a recursive directory listing command that produces a
      depth indented listing of files, which is colorized ala dircolors if
      the LS_COLORS environment variable is set and output is to tty.
    '';

    platforms = lib.platforms.all;
    maintainers = [lib.maintainers.peti];
  };
}
