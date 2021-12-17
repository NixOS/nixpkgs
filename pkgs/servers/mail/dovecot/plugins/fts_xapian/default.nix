{ lib, stdenv, fetchFromGitHub, autoconf, automake, pkg-config, dovecot, libtool, xapian, icu64 }:
stdenv.mkDerivation rec {
  pname = "fts-xapian";
  version = "1.4.14";

  src = fetchFromGitHub {
    owner = "grosjo";
    repo = "fts-xapian";
    rev = version;
    sha256 = "sha256-Banyg10AiM1Jw6Zfl4Dcpc0/6Km48lLVuQ3xRLylE7k=";
  };

  buildInputs = [ dovecot xapian icu64 ];

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

  meta = with lib; {
    homepage = "https://github.com/grosjo/fts-xapian";
    description = "Dovecot FTS plugin based on Xapian";
    changelog = "https://github.com/grosjo/fts-xapian/releases";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ julm symphorien ];
    platforms = platforms.unix;
  };
}
