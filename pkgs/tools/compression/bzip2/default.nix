{ stdenv, fetchurl
, linkStatic ? (stdenv.system == "i686-cygwin")
}:

stdenv.mkDerivation rec {
  name = "bzip2-${version}";
  version = "1.0.6.0.1";

  /* We use versions patched to use autotools style properly,
      saving lots of trouble. */
  src = fetchurl {
    urls = map
      (prefix: prefix + "/people/sbrabec/bzip2/tarballs/${name}.tar.gz")
      [
        "http://ftp.uni-kl.de/pub/linux/suse"
        "ftp://ftp.hs.uni-hamburg.de/pub/mirrors/suse"
        "ftp://ftp.mplayerhq.hu/pub/linux/suse"
        "http://ftp.suse.com/pub" # the original patched version but slow
      ];
    sha256 = "0b5b5p8c7bslc6fslcr1nj9136412v3qcvbg6yxi9argq9g72v8c";
  };

  postPatch = ''
    sed -i -e '/<sys\\stat\.h>/s|\\|/|' bzip2.c
  '';

  outputs = [ "dev" "bin" "out" "man" ];

  configureFlags =
    stdenv.lib.optionals linkStatic [ "--enable-static" "--disable-shared" ];

  meta = {
    homepage = "http://www.bzip.org";
    description = "high-quality data compression program";

    platforms = stdenv.lib.platforms.all;
    maintainers = [];
  };
}
