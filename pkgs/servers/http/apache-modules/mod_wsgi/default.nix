{ stdenv, fetchurl, apacheHttpd, python }:

stdenv.mkDerivation {
  name = "mod_wsgi-3.4";

  src = fetchurl {
    url = "http://modwsgi.googlecode.com/files/mod_wsgi-3.4.tar.gz";
    sha256 = "1s5nnjssvcl6lzy7kxmrk47yz6sgfzk90i1y7jml0s0lks7ck1df";
  };

  buildInputs = [ apacheHttpd python ];

  patchPhase = ''
    sed -r -i -e "s|^LIBEXECDIR=.*$|LIBEXECDIR=$out/modules|" \
      ${if stdenv.isDarwin then "-e 's|/usr/bin/lipo|lipo|'" else ""} \
      configure
  '';

  meta = {
    homepage = "http://code.google.com/p/modwsgi/";
    description = "Host Python applications in Apache through the WSGI interface";
    license = stdenv.lib.licenses.asl20;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
