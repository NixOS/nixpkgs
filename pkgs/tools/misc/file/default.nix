{ lib, stdenv, fetchurl, file, zlib, libgnurx, fetchpatch }:

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

  patches = [
    # Fix the mime type detection of xz file. Is merged in master.
    (fetchpatch {
      url = "https://github.com/file/file/commit/9b0459afab309a82aa4e46f73a4e50dd641f3d39.patch";
      sha256 = "sha256-6vjyIn5gVbgmhUlfXJKFRVltm8YKATKmh0/X6+2lLnM=";
    })
  ];

  doCheck = true;

  makeFlags = lib.optional stdenv.hostPlatform.isWindows "FILE_COMPILE=file";

  meta = with lib; {
    homepage = "https://darwinsys.com/file";
    description = "A program that shows the type of files";
    maintainers = with maintainers; [ ];
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
