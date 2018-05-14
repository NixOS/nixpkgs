{ stdenv, fetchFromGitHub, cmake }:

# ?TODO: there's also python lib in there

stdenv.mkDerivation rec {
  name = "brotli-${version}";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "google";
    repo = "brotli";
    rev = "v" + version;
    sha256 = "1hlkqgkm2gv6q83dswg6b19hpw8j33y6iw924j8r647pd4qg1xs7";
  };

  nativeBuildInputs = [ cmake ];

  outputs = [ "out" "dev" "lib" ];

  doCheck = true;

  checkTarget = "test";

  # This breaks on Darwin because our cmake hook tries to make a build folder
  # and the wonderful bazel BUILD file is already there (yay case-insensitivity?)
  prePatch = "rm BUILD";

  # Don't bother with "man" output for now,
  # it currently only makes the manpages hard to use.
  postInstall = ''
    mkdir -p $out/share/man/man{1,3}
    cp ../docs/*.1 $out/share/man/man1/
    cp ../docs/*.3 $out/share/man/man3/
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
    maintainers = [ maintainers.vcunat ];
    platforms = platforms.all;
  };
}

