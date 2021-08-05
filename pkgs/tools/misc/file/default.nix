{ lib, stdenv, fetchurl, file, zlib, libgnurx }:

stdenv.mkDerivation rec {
  pname = "file";
  version = "5.40";

  src = fetchurl {
    urls = [
      "ftp://ftp.astron.com/pub/file/${pname}-${version}.tar.gz"
      "https://distfiles.macports.org/file/${pname}-${version}.tar.gz"
    ];
    sha256 = "0myxlpj9gy2diqavx33vq88kpvr1k1bpzsm0d0zmb2hl7ks22wqn";
  };

  nativeBuildInputs = lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) file;
  buildInputs = [ zlib ]
              ++ lib.optional stdenv.hostPlatform.isWindows libgnurx;

  doCheck = true;

  makeFlags = lib.optional stdenv.hostPlatform.isWindows "FILE_COMPILE=file";

  meta = with lib; {
    homepage = "https://darwinsys.com/file";
    description = "A program that shows the type of files";
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
