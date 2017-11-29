{ stdenv, fetchFromGitHub, cmake }:

# ?TODO: there's also python lib in there

stdenv.mkDerivation rec {
  name = "brotli-${version}";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "brotli";
    rev = "v" + version;
    sha256 = "1rqgp8xi1k4sjy9sngg1vw0v8q2mm46dhyya4d35n3k6yk7pk0qv";
  };

  buildInputs = [ cmake ];

  # This breaks on Darwin because our cmake hook tries to make a build folder
  # and the wonderful bazel BUILD file is already there (yay case-insensitivity?)
  prePatch = "rm BUILD";

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
    maintainers = [ maintainers.vcunat ];
    platforms = platforms.all;
  };
}

