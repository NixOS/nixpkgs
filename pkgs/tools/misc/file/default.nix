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

  patches = [
    # https://github.com/file/file/commit/85b7ab83257b3191a1a7ca044589a092bcef2bb3
    # Without the RCS id change to avoid conflicts. Remove on next bump.
    ./webassembly-format-fix.patch
  ];

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
