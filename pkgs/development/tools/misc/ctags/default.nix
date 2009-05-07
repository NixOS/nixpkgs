{stdenv, fetchurl, bleedingEdgeRepos, automake, autoconf}:

stdenv.mkDerivation rec {
  name = "ctags-svn";
  src = bleedingEdgeRepos.sourceByName "ctags";

  preConfigure = ''
    autoheader
    autoconf
  '';

  buildInputs = [ automake autoconf ];
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
