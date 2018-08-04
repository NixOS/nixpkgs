{ stdenv, fetchurl, fetchpatch, oniguruma }:

stdenv.mkDerivation rec {
  name = "jq-${version}";
  version="1.5";

  src = fetchurl {
    url="https://github.com/stedolan/jq/releases/download/jq-${version}/jq-${version}.tar.gz";
    sha256="0g29kyz4ykasdcrb0zmbrp2jqs9kv1wz9swx849i2d1ncknbzln4";
  };

  outputs = [ "bin" "doc" "man" "dev" "lib" "out" ];

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
  ]
    ++ stdenv.lib.optional stdenv.isDarwin ./darwin-strptime-test.patch;

  patchFlags = [ "-p2" ]; # `src` subdir was introduced after v1.5 was released

  configureFlags =
    [
    "--bindir=\${bin}/bin"
    "--sbindir=\${bin}/bin"
    "--datadir=\${doc}/share"
    "--mandir=\${man}/share/man"
    ]
    # jq is linked to libjq:
    ++ stdenv.lib.optional (!stdenv.isDarwin) "LDFLAGS=-Wl,-rpath,\\\${libdir}";

  doInstallCheck = true;
  installCheckTarget = "check";

  postInstallCheck = ''
    $bin/bin/jq --help >/dev/null
  '';

  meta = with stdenv.lib; {
    description = ''A lightweight and flexible command-line JSON processor'';
    license = licenses.mit;
    maintainers = with maintainers; [ raskin ];
    platforms = with platforms; linux ++ darwin;
    downloadPage = "http://stedolan.github.io/jq/download/";
    updateWalker = true;
    inherit version;
  };
}
