{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  bash,
  gnugrep,
  fixDarwinDylibNames,
  file,
  legacySupport ? false,
  static ? stdenv.hostPlatform.isStatic, # generates static libraries *only*
  enableStatic ? static,
  # these need to be ran on the host, thus disable when cross-compiling
  buildContrib ? stdenv.hostPlatform == stdenv.buildPlatform,
  doCheck ? stdenv.hostPlatform == stdenv.buildPlatform,
  nix-update-script,

  # for passthru.tests
  libarchive,
  rocksdb,
  arrow-cpp,
  libzip,
  curl,
  python3Packages,
  haskellPackages,
}:

stdenv.mkDerivation rec {
  pname = "zstd";
  version = "1.5.6";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "zstd";
    rev = "v${version}";
    hash = "sha256-qcd92hQqVBjMT3hyntjcgk29o9wGQsg5Hg7HE5C0UNc=";
  };

  nativeBuildInputs = [ cmake ] ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;
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

  cmakeFlags =
    lib.attrsets.mapAttrsToList (name: value: "-DZSTD_${name}:BOOL=${if value then "ON" else "OFF"}")
      {
        BUILD_SHARED = !static;
        BUILD_STATIC = enableStatic;
        BUILD_CONTRIB = buildContrib;
        PROGRAMS_LINK_SHARED = !static;
        LEGACY_SUPPORT = legacySupport;
        BUILD_TESTS = doCheck;
      };

  cmakeDir = "../build/cmake";
  dontUseCmakeBuildDir = true;
  preConfigure = ''
    mkdir -p build_ && cd $_
  '';

  nativeCheckInputs = [ file ];
  inherit doCheck;
  checkPhase = ''
    runHook preCheck
    # Patch shebangs for playTests
    patchShebangs ../programs/zstdgrep
    ctest -R playTests # The only relatively fast test.
    runHook postCheck
  '';

  preInstall =
    ''
      mkdir -p $bin/bin
      substituteInPlace ../programs/zstdgrep \
        --replace ":-grep" ":-${gnugrep}/bin/grep" \
        --replace ":-zstdcat" ":-$bin/bin/zstdcat"

      substituteInPlace ../programs/zstdless \
        --replace "zstdcat" "$bin/bin/zstdcat"
    ''
    + lib.optionalString buildContrib (
      ''
        cp contrib/pzstd/pzstd $bin/bin/pzstd
      ''
      + lib.optionalString stdenv.isDarwin ''
        install_name_tool -change @rpath/libzstd.1.dylib $out/lib/libzstd.1.dylib $bin/bin/pzstd
      ''
    );

  outputs =
    [
      "bin"
      "dev"
    ]
    ++ lib.optional stdenv.hostPlatform.isUnix "man"
    ++ [ "out" ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit libarchive rocksdb arrow-cpp;
      libzip = libzip.override { withZstd = true; };
      curl = curl.override { zstdSupport = true; };
      python-zstd = python3Packages.zstd;
      haskell-zstd = haskellPackages.zstd;
      haskell-hs-zstd = haskellPackages.hs-zstd;
    };
  };

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
    mainProgram = "zstd";
    platforms = platforms.all;
    maintainers = with maintainers; [ orivej ];
  };
}
