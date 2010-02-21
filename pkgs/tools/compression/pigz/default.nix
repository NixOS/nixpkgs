{stdenv, fetchurl, zlib}:

let name = "pigz";
    version = "2.1.6";
in
stdenv.mkDerivation {
  name = name + "-" + version;

  src = fetchurl {
    url = "http://www.zlib.net/${name}/${name}-${version}.tar.gz";
    sha256 = "2ff1ba812407848787fe6719fde4436cb7c490e6d8c6e721f4e4309caa5f3640";
  };

  buildInputs = [zlib];
  doCheck = false;  # The makefile is broken in 2.1.5. Should be fixed upstream.
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
    homepage = http://www.zlib.net/pigz/;
    description = "A parallel implementation of gzip for multi-core machines";
  };
}
