{ stdenv, lib, fetchurl, fetchpatch, oniguruma }:

stdenv.mkDerivation rec {
  name = "jq-${version}";
  version="1.5";

  src = fetchurl {
    url="https://github.com/stedolan/jq/releases/download/jq-${version}/jq-${version}.tar.gz";
    sha256="0g29kyz4ykasdcrb0zmbrp2jqs9kv1wz9swx849i2d1ncknbzln4";
  };

  buildInputs = [ oniguruma ];

  patches = [
    (fetchpatch {
      name = "CVE-2015-8863.patch";
      url = https://github.com/stedolan/jq/commit/8eb1367ca44e772963e704a700ef72ae2e12babd.diff;
      sha256 = "18bjanzvklfzlzzd690y88725l7iwl4f6wnr429na5pfmircbpvh";
    })
    (fetchpatch {
      name = "CVE-2016-4074.patch";
      url = https://patch-diff.githubusercontent.com/raw/stedolan/jq/pull/1214.diff;
      sha256 = "1w8bapnyp56di6p9casbfczfn8258rw0z16grydavdjddfm280l9";
    })
  ];
  patchFlags = [ "-p2" ]; # `src` subdir was introduced after v1.5 was released

  # jq is linked to libjq:
  configureFlags = [
    "LDFLAGS=-Wl,-rpath,\\\${libdir}"
  ];

  meta = {
    description = ''A lightweight and flexible command-line JSON processor'';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = with lib.platforms; linux ++ darwin;
    downloadPage = "http://stedolan.github.io/jq/download/";
    updateWalker = true;
    inherit version;
  };
}
