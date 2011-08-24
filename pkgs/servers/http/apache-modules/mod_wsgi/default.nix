{ stdenv, fetchurl, apacheHttpd, python }:

stdenv.mkDerivation {
  name = "mod_wsgi-3.3";

  src = fetchurl {
    url = "http://modwsgi.googlecode.com/files/mod_wsgi-3.3.tar.gz";
    sha256 = "0hrjksym0dlqn1ka1yf3x6ar801zqxfykwcxazjwz104k5w10vnr";
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
    license = "ASL2.0";

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
