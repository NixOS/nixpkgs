{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  version = "0.3.111";
  pname = "libaio";

  src = fetchurl {
    url = "https://pagure.io/libaio/archive/${pname}-${version}/${pname}-${pname}-${version}.tar.gz";
    sha256 = "1fih2y2js0dl9qshpyb14m0nnxlms2527shgcxg0hnbflv5igg76";
  };

  postPatch = ''
    patchShebangs harness

    # Makefile is too optimistic, gcc is too smart
    substituteInPlace harness/Makefile \
      --replace "-Werror" ""
  '';

  makeFlags = [
    "prefix=${placeholder ''out''}"
  ];

  hardeningDisable = stdenv.lib.optional (stdenv.isi686) "stackprotector";

  checkTarget = "partcheck"; # "check" needs root

  meta = {
    description = "Library for asynchronous I/O in Linux";
    homepage = "http://lse.sourceforge.net/io/aio.html";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ ];
  };
}
