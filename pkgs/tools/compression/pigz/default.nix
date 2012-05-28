{ stdenv, fetchurl, zlib, utillinux }:

let name = "pigz";
    version = "2.2.4";
in
stdenv.mkDerivation {
  name = name + "-" + version;

  src = fetchurl {
    url = "http://www.zlib.net/${name}/${name}-${version}.tar.gz";
    sha256 = "7e7967c47f66c07be97cbfa25c8816b72f9d35258466ea31eddc7666c914160e";
  };

  buildInputs = [zlib] ++ stdenv.lib.optional stdenv.isLinux utillinux;

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

  meta = {
    homepage = "http://www.zlib.net/pigz/";
    description = "A parallel implementation of gzip for multi-core machines";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
