{ lib, stdenv, fetchFromGitHub, cmake, bash, gnugrep
, fixDarwinDylibNames
, file
, legacySupport ? false
, static ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "zstd";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "zstd";
    rev = "v${version}";
    sha256 = "0icc0x89c35rq5bxd4d241vqxnz2i1qj2wwy01xls63p0z93brj7";
  };

  nativeBuildInputs = [ cmake ]
   ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;
  buildInputs = lib.optional stdenv.hostPlatform.isUnix bash;

  patches = [
    # This patches makes sure we do not attempt to use the MD5 implementation
    # of the host platform when running the tests
    ./playtests-darwin.patch
  ];

  postPatch = lib.optionalString (!static) ''
    substituteInPlace build/cmake/CMakeLists.txt \
      --replace 'message(SEND_ERROR "You need to build static library to build tests")' ""
    substituteInPlace build/cmake/tests/CMakeLists.txt \
      --replace 'libzstd_static' 'libzstd_shared'
    sed -i \
      "1aexport ${lib.optionalString stdenv.isDarwin "DY"}LD_LIBRARY_PATH=$PWD/build_/lib" \
      tests/playTests.sh
  '';

  cmakeFlags = lib.attrsets.mapAttrsToList
    (name: value: "-DZSTD_${name}:BOOL=${if value then "ON" else "OFF"}") {
      BUILD_SHARED = !static;
      BUILD_STATIC = static;
      BUILD_CONTRIB = true;
      PROGRAMS_LINK_SHARED = !static;
      LEGACY_SUPPORT = legacySupport;
      BUILD_TESTS = doCheck;
    };

  cmakeDir = "../build/cmake";
  dontUseCmakeBuildDir = true;
  preConfigure = ''
    mkdir -p build_ && cd $_
  '';

  checkInputs = [ file ];
  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;
  checkPhase = ''
    runHook preCheck
    # Patch shebangs for playTests
    patchShebangs ../programs/zstdgrep
    ctest -R playTests # The only relatively fast test.
    runHook postCheck
  '';

  preInstall = ''
    mkdir -p $bin/bin
    cp contrib/pzstd/pzstd $bin/bin/pzstd
    substituteInPlace ../programs/zstdgrep \
      --replace ":-grep" ":-${gnugrep}/bin/grep" \
      --replace ":-zstdcat" ":-$bin/bin/zstdcat"

    substituteInPlace ../programs/zstdless \
      --replace "zstdcat" "$bin/bin/zstdcat"
  '' + lib.optionalString stdenv.isDarwin ''
    install_name_tool -change @rpath/libzstd.1.dylib $out/lib/libzstd.1.dylib $bin/bin/pzstd
  '';

  outputs = [ "bin" "dev" ]
    ++ lib.optional stdenv.hostPlatform.isUnix "man"
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
