{ stdenv, fetchFromGitHub, fetchpatch, cmake, gnugrep
, fixDarwinDylibNames
, file
, legacySupport ? false
, enableShared ? true }:

stdenv.mkDerivation rec {
  pname = "zstd";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "zstd";
    rev = "v${version}";
    sha256 = "0ay3qlk4sffnmcl3b34q4zd7mkcmjds023icmib1mdli97qcp38l";
  };

  nativeBuildInputs = [ cmake ]
   ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  patches = [
    ./playtests-darwin.patch
    (fetchpatch {
      url = "https://github.com/facebook/zstd/pull/2163.patch";
      sha256 = "07mfjc5f9wy0w2xlj36hyf7g5ax9r2rf6ixhkffhnwc6rwy0q54p";
    })
  ] # This I didn't upstream because if you use posix threads with MinGW it will
    # work fine, and I'm not sure how to write the condition.
    ++ stdenv.lib.optional stdenv.hostPlatform.isWindows ./mcfgthreads-no-pthread.patch;

  cmakeFlags = [
    "-DZSTD_BUILD_SHARED:BOOL=${if enableShared then "ON" else "OFF"}"
    # They require STATIC for bin/zstd and tests.
    "-DZSTD_LEGACY_SUPPORT:BOOL=${if legacySupport then "ON" else "OFF"}"
    "-DZSTD_BUILD_TESTS:BOOL=ON"
  ];
  cmakeDir = "../build/cmake";
  dontUseCmakeBuildDir = true;
  preConfigure = ''
    mkdir -p build_ && cd $_
  '';

  checkInputs = [ file ];
  doCheck = true;
  checkPhase = ''
    runHook preCheck
    ctest -R playTests # The only relatively fast test.
    runHook postCheck
  '';

  preInstall = ''
    substituteInPlace ../programs/zstdgrep \
      --replace ":-grep" ":-${gnugrep}/bin/grep" \
      --replace ":-zstdcat" ":-$out/bin/zstdcat"

    substituteInPlace ../programs/zstdless \
      --replace "zstdcat" "$out/bin/zstdcat"
  '';
  # Don't duplicate the library code in runtime closures.
  postInstall = stdenv.lib.optionalString enableShared ''rm "$out"/lib/libzstd.a'';

  meta = with stdenv.lib; {
    description = "Zstandard real-time compression algorithm";
    longDescription = ''
      Zstd, short for Zstandard, is a fast lossless compression algorithm,
      targeting real-time compression scenarios at zlib-level compression
      ratio. Zstd can also offer stronger compression ratio at the cost of
      compression speed. Speed/ratio trade-off is configurable by small
      increment, to fit different situations. Note however that decompression
      speed is preserved and remain roughly the same at all settings, a
      property shared by most LZ compression algorithms, such as zlib.
    '';
    homepage = "https://facebook.github.io/zstd/";
    license = with licenses; [ bsd3 ]; # Or, at your opinion, GPL-2.0-only.

    platforms = platforms.all;
    maintainers = with maintainers; [ orivej ];
  };
}
