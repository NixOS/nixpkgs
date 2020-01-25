{ stdenv, fetchurl, fetchpatch, file, zlib, libgnurx }:

stdenv.mkDerivation rec {
  pname = "file";
  version = "5.37";

  src = fetchurl {
    urls = [
      "ftp://ftp.astron.com/pub/file/${pname}-${version}.tar.gz"
      "https://distfiles.macports.org/file/${pname}-${version}.tar.gz"
    ];
    sha256 = "0zz0p9bqnswfx0c16j8k62ivjq1m16x10xqv4hy9lcyxyxkkkhg9";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2019-18218.patch";
      urls = [
        "https://src.fedoraproject.org/rpms/file/raw/f6dd8461/f/file-5.37-CVE-2019-18218.patch"
        "https://git.in-ulm.de/cbiedl/file/raw/054940e842528dca434a92820f9abb89adce0574/debian/patches/cherry-pick.FILE5_37-67-g46a8443f.limit-the-number-of-elements-in-a-vector-found-by-oss-fuzz.patch"
        "https://sources.debian.org/data/main/f/file/1:5.35-4+deb10u1/debian/patches/cherry-pick.FILE5_37-67-g46a8443f.limit-the-number-of-elements-in-a-vector-found-by-oss-fuzz.patch"
      ];
      sha256 = "1i22y91yndc3n2p2ngczp1lwil8l05sp8ciicil74xrc5f91y6mj";
    })
  ];

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
