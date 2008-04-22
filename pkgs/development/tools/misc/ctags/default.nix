{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "ctags-5.7";
  src = fetchurl {
    url = "mirror://sourceforge/ctags/${name}.tar.gz";
    sha256 = "10623bbcc9b0cb60124271ce83111733a1043ab022d51cfcd2c0e0c953bd8b58";
  };

  meta = {
    description = "Exuberant Ctags, a tool for fast source code browsing";

    longDescription = ''
      Ctags generates an index (or tag) file of language objects found
      in source files that allows these items to be quickly and easily
      located by a text editor or other utility.  A tag signifies a
      language object for which an index entry is available (or,
      alternatively, the index entry created for that object).  Many
      programming languages are supported.
    '';

    homepage = http://ctags.sourceforge.net/;

    license = "GPLv2+";
  };
}
