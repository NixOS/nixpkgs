{ fetchurl, lib, stdenv, libtool, gettext, zlib, readline, gsasl
, guile, python3, pcre, libffi, groff, libxcrypt }:

stdenv.mkDerivation rec {
  pname = "dico";
  version = "2.11";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-rB+Y4jPQ+srKrBBZ87gThKVZLib9TDCCrtAD9l4lLFo=";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ groff ];

  buildInputs =
    [ libtool gettext zlib readline gsasl guile python3 pcre libffi libxcrypt ];

  strictDeps = true;

  doCheck = true;

  meta = with lib; {
    description = "Flexible dictionary server and client implementing RFC 2229";
    homepage    = "https://www.gnu.org/software/dico/";
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;

    longDescription = ''
      GNU Dico is a flexible modular implementation of DICT server
      (RFC 2229).  In contrast to another existing servers, it does
      not depend on particular database format, instead it handles
      database accesses using loadable modules.

      The package includes several loadable modules for interfacing
      with various database formats, among them a module for dict.org
      databases and a module for transparently accessing Wikipedia or
      Wiktionary sites as a dictionary database.

      New modules can easily be written in C, Guile or Python.  The
      module API is mature and well documented.

      A web interface serving several databases is available.

      The package also includes a console client program for querying
      remote dictionary servers.
    '';
  };
}
