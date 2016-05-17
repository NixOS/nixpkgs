{ stdenv, fetchurl, zlib, utillinux }:

let name = "pigz";
    version = "2.3.3";
in
stdenv.mkDerivation {
  name = name + "-" + version;

  src = fetchurl {
    url = "http://www.zlib.net/${name}/${name}-${version}.tar.gz";
    sha256 = "172hdf26k4zmm7z8md7nl0dph2a7mhf3x7slb9bhfyff6as6g2sf";
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
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
