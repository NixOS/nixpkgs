{ lib, stdenv, fetchFromGitHub, cmake, bash, gnugrep
, fixDarwinDylibNames
, file
, legacySupport ? false
, static ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "zstd";
  version = "1.4.8";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "zstd";
    rev = "v${version}";
    sha256 = "018zgigp5xlrb4mgshgrvns0cfbhhcg89cifbjj4rv6s3n9riphw";
  };

  nativeBuildInputs = [ cmake ]
   ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;
  buildInputs = stdenv.lib.optional stdenv.hostPlatform.isUnix bash;

  patches = [
    ./playtests-darwin.patch
  ] # This I didn't upstream because if you use posix threads with MinGW it will
    # work fine, and I'm not sure how to write the condition.
    ++ stdenv.lib.optional stdenv.hostPlatform.isWindows ./mcfgthreads-no-pthread.patch;

  postPatch = stdenv.lib.optionalString (!static) ''
    substituteInPlace build/cmake/CMakeLists.txt \
      --replace 'message(SEND_ERROR "You need to build static library to build tests")' ""
    substituteInPlace build/cmake/tests/CMakeLists.txt \
      --replace 'libzstd_static' 'libzstd_shared'
    sed -i \
      "1aexport ${stdenv.lib.optionalString stdenv.isDarwin "DY"}LD_LIBRARY_PATH=$PWD/build_/lib" \
      tests/playTests.sh
  '';

  cmakeFlags = [
    "-DZSTD_BUILD_SHARED:BOOL=${if (!static) then "ON" else "OFF"}"
    "-DZSTD_BUILD_STATIC:BOOL=${if static then "ON" else "OFF"}"
    "-DZSTD_PROGRAMS_LINK_SHARED:BOOL=${if (!static) then "ON" else "OFF"}"
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
    # Patch shebangs for playTests
    patchShebangs ../programs/zstdgrep
    ctest -R playTests # The only relatively fast test.
    runHook postCheck
  '';

  preInstall = ''
    substituteInPlace ../programs/zstdgrep \
      --replace ":-grep" ":-${gnugrep}/bin/grep" \
      --replace ":-zstdcat" ":-$bin/bin/zstdcat"

    substituteInPlace ../programs/zstdless \
      --replace "zstdcat" "$bin/bin/zstdcat"
  '';

  outputs = [ "bin" "dev" ]
    ++ stdenv.lib.optional stdenv.hostPlatform.isUnix "man"
    ++ [ "out" ];

  meta = with lib; {
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
    changelog = "https://github.com/facebook/zstd/blob/v${version}/CHANGELOG";
    license = with licenses; [ bsd3 ]; # Or, at your opinion, GPL-2.0-only.

    platforms = platforms.all;
    maintainers = with maintainers; [ orivej ];
  };
}
