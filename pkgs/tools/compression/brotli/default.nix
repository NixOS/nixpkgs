{ stdenv, fetchFromGitHub, cmake, fetchpatch, staticOnly ? false }:

# ?TODO: there's also python lib in there

stdenv.mkDerivation rec {
  pname = "brotli";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "google";
    repo = "brotli";
    rev = "v" + version;
    sha256 = "z6Dhrabav1MDQ4rAcXaDv0aN+qOoh9cvoXZqEWBB13c=";
  };

  nativeBuildInputs = [ cmake ];

  patches = stdenv.lib.optional staticOnly (fetchpatch {
    # from https://github.com/google/brotli/pull/655
    url = "https://github.com/google/brotli/commit/7289e5a378ba13801996a84d89d8fe95c3fc4c11.patch";
    sha256 = "1bghbdvj24jrvb0sqfdif9vwg7wx6pn8dvl6flkrcjkhpj0gi0jg";
  });

  cmakeFlags = []
    ++ stdenv.lib.optional staticOnly "-DBUILD_SHARED_LIBS=OFF";

  outputs = [ "out" "dev" "lib" ];

  doCheck = true;

  checkTarget = "test";

  # This breaks on Darwin because our cmake hook tries to make a build folder
  # and the wonderful bazel BUILD file is already there (yay case-insensitivity?)
  prePatch = ''
      rm BUILD

      # Upstream fixed this reference to runtime-path after the release
      # and with this references g++ complains about invalid option -R
      sed -i 's/ -R''${libdir}//' scripts/libbrotli*.pc.in
      cat scripts/libbrotli*.pc.in
    '';

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
