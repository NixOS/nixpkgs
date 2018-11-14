{ stdenv, fetchurl, file, zlib, libgnurx }:

stdenv.mkDerivation rec {
  name = "file-${version}";
  version = "5.34";

  src = fetchurl {
    urls = [
      "ftp://ftp.astron.com/pub/file/${name}.tar.gz"
      "https://distfiles.macports.org/file/${name}.tar.gz"
    ];
    sha256 = "02mj4g34l13facacsc0ff8rchbh93ccqw7hns45yqgx8pzdm0npi";
  };

  nativeBuildInputs = stdenv.lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) file;
  buildInputs = [ zlib ]
              ++ stdenv.lib.optional stdenv.hostPlatform.isWindows libgnurx;

  doCheck = true;

  makeFlags = if stdenv.hostPlatform.isWindows then "FILE_COMPILE=file"
              else null;

  meta = with stdenv.lib; {
    homepage = http://darwinsys.com/file;
    description = "A program that shows the type of files";
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
