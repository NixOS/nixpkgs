{ lib, stdenv, fetchurl, file, zlib, libgnurx }:

stdenv.mkDerivation rec {
  pname = "file";
  version = "5.41";

  src = fetchurl {
    urls = [
      "ftp://ftp.astron.com/pub/file/${pname}-${version}.tar.gz"
      "https://distfiles.macports.org/file/${pname}-${version}.tar.gz"
    ];
    sha256 = "sha256-E+Uyx7Nk99V+I9/uoxRxAxUMuQWTpXr4bBDk9uQRYD8=";
  };

  nativeBuildInputs = lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) file;
  buildInputs = [ zlib ]
    ++ lib.optional stdenv.hostPlatform.isWindows libgnurx;

  doCheck = true;

  makeFlags = lib.optional stdenv.hostPlatform.isWindows "FILE_COMPILE=file";

  meta = with lib; {
    homepage = "https://darwinsys.com/file";
    description = "A program that shows the type of files";
    maintainers = with maintainers; [ doronbehar ];
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
