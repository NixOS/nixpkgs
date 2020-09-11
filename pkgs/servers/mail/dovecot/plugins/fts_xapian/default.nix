{ stdenv, fetchFromGitHub, autoconf, automake, pkg-config, dovecot, libtool, xapian, icu64, sqlite }:
stdenv.mkDerivation {
  pname = "fts-xapian";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "grosjo";
    repo = "fts-xapian";
    rev = "1.3.1";
    sha256 = "10yl5fyfbx2ijqckx13vbmzj9mpm5pkh8qzichbdgplrzm738q43";
  };

  buildInputs = [ dovecot xapian icu64 sqlite ];

  nativeBuildInputs = [ autoconf automake libtool pkg-config ];

  preConfigure = ''
    export PANDOC=false
    autoreconf -vi
  '';

  configureFlags = [
    "--with-dovecot=${dovecot}/lib/dovecot"
    "--without-dovecot-install-dirs"
    "--with-moduledir=$(out)/lib/dovecot"
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/grosjo/fts-xapian";
    description = "Dovecot FTS plugin based on Xapian";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ julm ];
    platforms = platforms.unix;
  };
}
