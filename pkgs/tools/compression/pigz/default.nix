{ stdenv, fetchurl, zlib, utillinux }:

let name = "pigz";
    version = "2.4";
in
stdenv.mkDerivation {
  name = name + "-" + version;

  src = fetchurl {
    url = "https://www.zlib.net/${name}/${name}-${version}.tar.gz";
    sha256 = "0wsgw5vwl23jrnpsvd8v3xcp5k4waw5mk0164fynjhkv58i1dy54";
  };

  enableParallelBuilding = true;

  buildInputs = [zlib] ++ stdenv.lib.optional stdenv.isLinux utillinux;

  makeFlags = [ "CC=cc" ];

  doCheck = stdenv.isLinux;
  checkTarget = "tests";
  installPhase =
  ''
      install -Dm755 pigz "$out/bin/pigz"
      ln -s pigz "$out/bin/unpigz"
      install -Dm755 pigz.1 "$out/share/man/man1/pigz.1"
      ln -s pigz.1 "$out/share/man/man1/unpigz.1"
      install -Dm755 pigz.pdf "$out/share/doc/pigz/pigz.pdf"
  '';

  meta = with stdenv.lib; {
    homepage = http://www.zlib.net/pigz/;
    description = "A parallel implementation of gzip for multi-core machines";
    license = licenses.zlib;
    platforms = platforms.unix;
  };
}
