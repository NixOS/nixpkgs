{
  lib,
  stdenv,
  fetchurl,
  openssl,
}:
let
  # Let's not pull the whole apache httpd package
  mime_file = fetchurl {
    url = "https://raw.githubusercontent.com/apache/httpd/906e419c1f703360e2e8ec077b393347f993884f/docs/conf/mime.types";
    sha256 = "ef972fc545cbff4c0daa2b2e6b440859693b3c10435ee90f10fa6fffad800c16";
  };
in
stdenv.mkDerivation rec {
  pname = "webfs";
  version = "1.21";

  src = fetchurl {
    url = "https://www.kraxel.org/releases/webfs/${pname}-${version}.tar.gz";
    sha256 = "98c1cb93473df08e166e848e549f86402e94a2f727366925b1c54ab31064a62a";
  };

  patches = [ ./ls.c.patch ];

  buildInputs = [ openssl ];

  makeFlags = [
    "mimefile=${mime_file}"
    "prefix=$(out)"
  ];

  meta = with lib; {
    description = "HTTP server for purely static content";
    homepage = "http://linux.bytesex.org/misc/webfs.html";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ zimbatm ];
    mainProgram = "webfsd";
  };
}
