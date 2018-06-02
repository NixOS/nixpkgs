{ stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "ctags-${version}";
  version = "5.8";

  src = fetchurl {
    url = "mirror://sourceforge/ctags/ctags-${version}.tar.gz";
    sha256 = "1iwrkrpdcmzbjmrv6b8169fvw6pq8v1307mipc5rx5myr9fv8i0f";
  };

  nativeBuildInputs = [ autoreconfHook ];

  # lregex.c:411:4: error: format not a string literal and no format arguments [-Werror=format-security]
  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "A tool for fast source code browsing (exuberant ctags)";
    longDescription = ''
      Ctags generates an index (or tag) file of language objects found
      in source files that allows these items to be quickly and easily
      located by a text editor or other utility.  A tag signifies a
      language object for which an index entry is available (or,
      alternatively, the index entry created for that object).  Many
      programming languages are supported.
    '';
    homepage = http://ctags.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;

    # So that Exuberant ctags is preferred over emacs's ctags
    priority = 1;
  };

}
