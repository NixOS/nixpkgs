{ stdenv, fetchurl, file, zlib, libgnurx }:

stdenv.mkDerivation rec {
  pname = "file";
  version = "5.39";

  src = fetchurl {
    urls = [
      "ftp://ftp.astron.com/pub/file/${pname}-${version}.tar.gz"
      "https://distfiles.macports.org/file/${pname}-${version}.tar.gz"
    ];
    sha256 = "1lgs2w2sgamzf27kz5h7pajz7v62554q21fbs11n4mfrfrm2hpgh";
  };

  nativeBuildInputs = stdenv.lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) file;
  buildInputs = [ zlib ]
              ++ stdenv.lib.optional stdenv.hostPlatform.isWindows libgnurx;

  doCheck = true;

  makeFlags = stdenv.lib.optional stdenv.hostPlatform.isWindows "FILE_COMPILE=file";

  meta = with stdenv.lib; {
    homepage = "https://darwinsys.com/file";
    description = "A program that shows the type of files";
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
