{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "qprint-1.1";

  src = fetchurl {
    url = "http://www.fourmilab.ch/webtools/qprint/${name}.tar.gz";
    sha256 = "1701cnb1nl84rmcpxzq11w4cyj4385jh3gx4aqxznwf8a4fwmagz";
  };

  doCheck = true;

  checkTarget = "wringer";

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
  '';

  meta = {
    homepage = "http://www.fourmilab.ch/webtools/qprint/";
    license = stdenv.lib.licenses.publicDomain;
    description = "Encode and decode Quoted-Printable files";
    maintainers = [ stdenv.lib.maintainers.tv ];
    platforms = stdenv.lib.platforms.all;
  };

}
