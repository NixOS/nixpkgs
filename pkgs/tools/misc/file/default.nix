{ stdenv, fetchurl, file, zlib, libgnurx }:

stdenv.mkDerivation rec {
  name = "file-${version}";
  version = "5.35";

  src = fetchurl {
    urls = [
      "ftp://ftp.astron.com/pub/file/${name}.tar.gz"
      "https://distfiles.macports.org/file/${name}.tar.gz"
    ];
    sha256 = "0ijm1fabm68ykr1zbx0bxnka5jr3n42sj8y5mbkrnxs0fj0mxi1h";
  };

  nativeBuildInputs = stdenv.lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) file;
  buildInputs = [ zlib ]
              ++ stdenv.lib.optional stdenv.hostPlatform.isWindows libgnurx;

  doCheck = true;

  makeFlags = if stdenv.hostPlatform.isWindows then "FILE_COMPILE=file"
              else null;

  meta = with stdenv.lib; {
    homepage = https://darwinsys.com/file;
    description = "A program that shows the type of files";
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
