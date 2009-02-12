args:
args.stdenv.mkDerivation {
  name = "cgdb-0.6.4";

  src = args.fetchurl {
    url = http://prdownloads.sourceforge.net/cgdb/cgdb-0.6.4.tar.gz;
    sha256 = "10c03p3bbr1glyw7j2i2sv97riiksw972pdamcqdqrzzfdcly54w";
  };

  buildInputs =(with args; [readline ncurses]);

  meta = { 
      description = "curses interface to gdb";
      homepage = http://cgdb.sourceforge.net/;
      license ="GPLv2";
  };
}
