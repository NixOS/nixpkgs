{ stdenv, fetchurl, openssl, shared_mime_info }:
stdenv.mkDerivation rec {
  name = "webfs-${version}";
  version = "1.21";

  src = fetchurl {
    url = "https://www.kraxel.org/releases/webfs/${name}.tar.gz";
    sha256 = "98c1cb93473df08e166e848e549f86402e94a2f727366925b1c54ab31064a62a";
  };

  patches = [ ./ls.c.patch ];

  buildInputs = [ openssl ];

  makeFlags = [
    "mimefile=${shared_mime_info}/share/mime/globs"
    "prefix=$(out)"
  ];

  meta = with stdenv.lib; {
    description = "HTTP server for purely static content";
    homepage    = http://linux.bytesex.org/misc/webfs.html;
    license     = licenses.gpl2;
    platforms   = platforms.all;
    maintainers = with maintainers; [ zimbatm ];
  };
}
