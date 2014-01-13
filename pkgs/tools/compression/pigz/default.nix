{ stdenv, fetchurl, zlib, utillinux }:

let name = "pigz";
    version = "2.3.1";
in
stdenv.mkDerivation {
  name = name + "-" + version;

  src = fetchurl {
    url = "http://www.zlib.net/${name}/${name}-${version}.tar.gz";
    sha256 = "0m5gw134wfqy1wwqzla0f6c88bxys1sq5gs22zrphf9a8bjhr6v2";
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
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
