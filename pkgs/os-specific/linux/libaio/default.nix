{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  version = "0.3.112";
  pname = "libaio";

  src = fetchurl {
    url = "https://pagure.io/libaio/archive/${pname}-${version}/${pname}-${pname}-${version}.tar.gz";
    sha256 = "0wi2myh191sja13qj3claxhpfkngvy10x30f78hm9cxzkfr97kxp";
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
