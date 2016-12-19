{ stdenv, fetchFromGitHub }:

# ?TODO: there's also python lib in there

stdenv.mkDerivation rec {
  name = "brotli-20160112";
  version = "bed93862";

  src = fetchFromGitHub {
    owner = "google";
    repo = "brotli";
    rev = "bed93862608d4d232ebe6d229f04e48399775e8b";
    sha256 = "0g94kqh984qkbqbj4fpkkyji9wnbrb9cs32r9d6niw1sqfnfkd6f";
  };

  preConfigure = "cd tools";

  # Debian installs "brotli" instead of "bro" but let's keep upstream choice for now.
  installPhase = ''
    mkdir -p "$out/bin"
    mv ./bro "$out/bin/"
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;

    description = "A generic-purpose lossless compression algorithm and tool";

    longDescription =
      ''  Brotli is a generic-purpose lossless compression algorithm that
          compresses data using a combination of a modern variant of the LZ77
          algorithm, Huffman coding and 2nd order context modeling, with a
          compression ratio comparable to the best currently available
          general-purpose compression methods. It is similar in speed with
          deflate but offers more dense compression.

          The specification of the Brotli Compressed Data Format is defined
          in the following internet draft:
          http://www.ietf.org/id/draft-alakuijala-brotli
      '';

    license = licenses.mit;
    maintainers = [];
    platforms = platforms.all;
  };
}
