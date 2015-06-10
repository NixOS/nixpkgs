{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "zopfli-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "zopfli";
    rev = name;
    name = "${name}-src";
    sha256 = "0r2k3md24y5laslzsph7kh4synm5az4ppv64idrvjk5yh2qwwb62";
  };

  installPhase = ''
    install -D zopfli $out/bin/zopfli
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/google/zopfli;
    description = "A compression tool to perform very good, but slow, deflate or zlib compression";
    longDescription =
      ''Zopfli Compression Algorithm is a compression library programmed
        in C to perform very good, but slow, deflate or zlib compression.

        This library can only compress, not decompress. Existing zlib or
        deflate libraries can decompress the data.
      '';
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.asl20;
    maintainers = with maintainers; [ bobvanderlinden ];
  };
}
