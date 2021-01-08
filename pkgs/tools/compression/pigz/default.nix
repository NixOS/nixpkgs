{ stdenv, fetchurl, zlib, utillinux }:

stdenv.mkDerivation rec {
  pname = "pigz";
  version = "2.4";

  src = fetchurl {
    url = "https://www.zlib.net/pigz/pigz-${version}.tar.gz";
    sha256 = "0wsgw5vwl23jrnpsvd8v3xcp5k4waw5mk0164fynjhkv58i1dy54";
  };

  enableParallelBuilding = true;

  buildInputs = [ zlib ] ++ stdenv.lib.optional stdenv.isLinux utillinux;

  makeFlags = [ "CC=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc" ];

  doCheck = stdenv.isLinux;
  checkTarget = "tests";

  installPhase = ''
    install -Dm755 pigz "$out/bin/pigz"
    install -Dm755 pigz.1 "$out/share/man/man1/pigz.1"
    install -Dm755 pigz.pdf "$out/share/doc/pigz/pigz.pdf"
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.zlib.net/pigz/";
    description = "A parallel implementation of gzip for multi-core machines";
    license = licenses.zlib;
    platforms = platforms.unix;
  };
}
