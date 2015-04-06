{ stdenv, fetchFromGitHub, zlib, openssl, bison, flex }:

stdenv.mkDerivation rec {
  name = "charybdis-3.4.2-git22e4a9b";

  src = fetchFromGitHub {
    owner = "atheme";
    repo = "charybdis";
    rev = "22e4a9bc2b34915bf6e907e90d60bf7d002c7dc5";
    sha256 = "0i22hc9al1g6ffa6vqw0lxdy1zj2y0ixgmmhi0kbc3j6xqp78kwj";
  };

  configureFlags = [
    "--sysconfdir=/etc/charybdis"
    "--localstatedir=/var"
    "--disable-assert"
    "--enable-openssl=${openssl}"
    "--enable-ipv6"
    "--with-program-prefix=charybdis-"
  ];

  buildInputs = [ zlib openssl bison flex ];

  meta = {
    description = "Charybdis IRC Daemon";
    homepage    = http://www.atheme.org/projects/charybdis.html;
    license     = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.fpletz ];
    platforms   = stdenv.lib.platforms.all;
  };
}
