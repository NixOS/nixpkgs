{stdenv, fetchurl, sourceFromHead, automake, autoconf}:

stdenv.mkDerivation rec {
  name = "ctags-svn";
  # REGION AUTO UPDATE:      { name="ctags"; type = "svn"; url = "https://ctags.svn.sourceforge.net/svnroot/ctags/trunk"; }
  src= sourceFromHead "ctags-749.tar.gz"
               (fetchurl { url = "http://mawercer.de/~nix/repos/ctags-749.tar.gz"; sha256 = "01dd4bf2e55dbedc38def81febef60eece912cb7624df1c0a2cf1ed6e4bc4ecf"; });
  # END

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
