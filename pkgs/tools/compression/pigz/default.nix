{ lib, stdenv, fetchurl, zlib, util-linux }:

stdenv.mkDerivation rec {
  pname = "pigz";
  version = "2.6";

  src = fetchurl {
    url = "https://www.zlib.net/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-Lu17DXRJ0dcJA/KmLNYAXSYus6jJ6YaHvIy7WAnbKn0=";
  };

  enableParallelBuilding = true;

  buildInputs = [ zlib ] ++ lib.optional stdenv.isLinux util-linux;

  makeFlags = [ "CC=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc" ];

  doCheck = stdenv.isLinux;
  checkTarget = "tests";
  installPhase = ''
    install -Dm755 pigz "$out/bin/pigz"
    ln -s pigz "$out/bin/unpigz"
    install -Dm755 pigz.1 "$out/share/man/man1/pigz.1"
    ln -s pigz.1 "$out/share/man/man1/unpigz.1"
    install -Dm755 pigz.pdf "$out/share/doc/pigz/pigz.pdf"
  '';

  meta = with lib; {
    homepage = "https://www.zlib.net/pigz/";
    description = "A parallel implementation of gzip for multi-core machines";
    maintainers = with maintainers; [ ];
    license = licenses.zlib;
    platforms = platforms.unix;
  };
}
