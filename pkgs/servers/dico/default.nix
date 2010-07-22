{ fetchurl, stdenv, libtool, gettext, zlib, readline, gsasl
, guile, python }:

stdenv.mkDerivation rec {
  name = "dico-2.1";

  src = fetchurl {
    url = "mirror://gnu/dico/${name}.tar.gz";
    sha256 = "0cs4jxnz6g5xqrhkbnycn7jl9fs8jfjh33vza7i68m8qmjwx2vza";
  };

  # XXX: Add support for GNU SASL.
  buildInputs = [ libtool gettext zlib readline gsasl guile python ];

  doCheck = true;

  meta = {
    description = "GNU Dico, a flexible dictionary server and client implementing RFC 2229";

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

    homepage = http://www.gnu.org/software/dico/;

    license = "GPLv3+";
  };
}
