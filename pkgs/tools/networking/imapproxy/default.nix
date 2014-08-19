{stdenv, fetchurl, openssl, ncurses}:

stdenv.mkDerivation rec {
  name = "imapproxy-1.2.7";
  src = fetchurl {
    url = mirror://sourceforge/squirrelmail/squirrelmail-imap_proxy-1.2.7.tar.bz2;
    sha256 = "0j5fq755sxiz338ia93jrkiy64crv30g37pir5pxfys57q7d92nx";
  };

  buildInputs = [ openssl ncurses ];

  patchPhase = ''
    sed -i -e 's/-o \(root\|bin\) -g \(sys\|bin\)//' Makefile.in
  '';

  meta = {
    homepage = http://imapproxy.org/;
    description = "It proxies IMAP transactions caching server connections";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
