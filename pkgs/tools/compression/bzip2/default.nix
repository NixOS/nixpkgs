{ stdenv, fetchurl
, linkStatic ? (stdenv.hostPlatform.system == "i686-cygwin")
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "bzip2";
  version = "1.0.6.0.1";

  /* We use versions patched to use autotools style properly,
      saving lots of trouble. */
  src = fetchurl {
    urls = map
      (prefix: prefix + "/people/sbrabec/bzip2/tarballs/${pname}-${version}.tar.gz")
      [
        "http://ftp.uni-kl.de/pub/linux/suse"
        "ftp://ftp.hs.uni-hamburg.de/pub/mirrors/suse"
        "ftp://ftp.mplayerhq.hu/pub/linux/suse"
        "http://ftp.suse.com/pub" # the original patched version but slow
      ];
    sha256 = "0b5b5p8c7bslc6fslcr1nj9136412v3qcvbg6yxi9argq9g72v8c";
  };

  nativeBuildInputs = [ autoreconfHook ];

  patches = [
    ./CVE-2016-3189.patch
    ./cve-2019-12900.patch
  ];

  postPatch = ''
    sed -i -e '/<sys\\stat\.h>/s|\\|/|' bzip2.c
  '';

  outputs = [ "bin" "dev" "out" "man" ];

  configureFlags =
    stdenv.lib.optionals linkStatic [ "--enable-static" "--disable-shared" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "High-quality data compression program";
    license = licenses.bsdOriginal;
    platforms = platforms.all;
    maintainers = [];
  };
}
