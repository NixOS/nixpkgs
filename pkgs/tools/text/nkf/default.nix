{ lib, stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "nkf";
  version = "2.1.5";

  src = fetchurl {
    url = "mirror://osdn/nkf/70406/${pname}-${version}.tar.gz";
    sha256 = "0i5dbcb9aipwr8ym4mhvgf1in3frl6y8h8x96cprz9s7b11xz9yi";
  };

  patches = [
    # Pull upstream fix for parllel build failures
    (fetchpatch {
      name = "parallel-install.patch";
      url = "http://git.osdn.net/view?p=nkf/nkf.git;a=patch;h=9ccff5975bec7963e591e042e1ab1139252a4dc9";
      sha256 = "00f0x414gfch650b20w0yj5x2bd67hchmadl7v54lk3vdgkc6jwj";
    })
  ];

  makeFlags = [ "prefix=$(out)" ];

  meta = {
    description = "Tool for converting encoding of Japanese text";
    homepage = "https://nkf.osdn.jp/";
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.auntie ];
  };
}
