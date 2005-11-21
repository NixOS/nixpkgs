{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "ctags-5.5.4";
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/ctags/ctags-5.5.4.tar.gz;
    md5 = "a84124caadd4103270e0b84596ecfe83";
  };
}
