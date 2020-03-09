{ stdenv, fetchFromGitHub, fetchpatch, cmake, gnugrep
, fixDarwinDylibNames
, file
, legacySupport ? false
, enableShared ? true }:

stdenv.mkDerivation rec {
  pname = "zstd";
  version = "1.4.4";

  src = fetchFromGitHub {
    sha256 = "0zn7r8d4m8w2lblnjalqpz18na0spzkdiw3fwq2fzb7drhb32v54";
    rev = "v${version}";
    repo = "zstd";
    owner = "facebook";
  };

  nativeBuildInputs = [ cmake ]
   ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  patches = [
    # From https://github.com/facebook/zstd/pull/1883
    (fetchpatch {
      url = "https://github.com/facebook/zstd/commit/106278e7e5fafaea3b7deb4147bdc8071562d2f0.diff";
      sha256 = "13z7id1qbc05cv1rmak7c8xrchp7jh1i623bq5pwcihg57wzcyr8";
    })
  ] # This I didn't upstream because if you use posix threads with MinGW it will
    # work find, and I'm not sure how to write the condition.
    ++ stdenv.lib.optional stdenv.hostPlatform.isWindows ./mcfgthreads-no-pthread.patch;

  cmakeFlags = [
    "-DZSTD_BUILD_SHARED:BOOL=${if enableShared then "ON" else "OFF"}"
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
  preCheck = ''
    substituteInPlace ../tests/playTests.sh \
      --replace 'MD5SUM="md5 -r"' 'MD5SUM="md5sum"'
  '';

  preInstall = stdenv.lib.optionalString enableShared ''
    substituteInPlace ../programs/zstdgrep \
      --replace ":-grep" ":-${gnugrep}/bin/grep" \
      --replace ":-zstdcat" ":-$out/bin/zstdcat"

    substituteInPlace ../programs/zstdless \
      --replace "zstdcat" "$out/bin/zstdcat"
  '';

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
    homepage = https://facebook.github.io/zstd/;
    license = with licenses; [ bsd3 ]; # Or, at your opinion, GPL-2.0-only.

    platforms = platforms.all;
    maintainers = with maintainers; [ orivej ];
  };
}
