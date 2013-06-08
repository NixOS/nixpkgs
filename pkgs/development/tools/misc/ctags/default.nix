{ stdenv, fetchsvn, automake, autoconf}:

stdenv.mkDerivation rec {
  name = "ctags-${revision}";
  revision = "804";

  src = fetchsvn {
    url = "http://ctags.svn.sourceforge.net/svnroot/ctags/trunk";
    rev = revision;
    sha256 = "16gln1mah2jqp32ki1z0187dwkbjx1xcnmyiardcq6c9w3p4qwcr";
  };

  buildInputs = [ automake autoconf ];

  preConfigure = "autoreconf -i";

  # don't use $T(E)MP which is set to the build directory
  configureFlags="--enable-tmpdir=/tmp";

  meta = {
    homepage = "http://ctags.sourceforge.net/";
    description = "Exuberant Ctags, a tool for fast source code browsing";
    license = stdenv.lib.licenses.gpl2Plus;

    longDescription = ''
      Ctags generates an index (or tag) file of language objects found
      in source files that allows these items to be quickly and easily
      located by a text editor or other utility.  A tag signifies a
      language object for which an index entry is available (or,
      alternatively, the index entry created for that object).  Many
      programming languages are supported.
    '';

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };

}
