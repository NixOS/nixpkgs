<<<<<<< HEAD
{ lib
, llvmPackages
, fetchFromGitHub
, fetchpatch
, cmake
, ninja
, python3
, perl
, yasm
, nixosTests
, darwin
, findutils

# currently for BLAKE3 hash function
, rustSupport ? true

, corrosion
, rustc
, cargo
, rustPlatform
}:

let
  inherit (llvmPackages) stdenv;
  mkDerivation = (
    if stdenv.isDarwin
    then darwin.apple_sdk_11_0.llvmPackages_15.stdenv
    else llvmPackages.stdenv).mkDerivation;
in mkDerivation rec {
  pname = "clickhouse";
  version = "23.3.13.6";

  src = fetchFromGitHub rec {
    owner = "ClickHouse";
    repo = "ClickHouse";
    rev = "v${version}-lts";
    fetchSubmodules = true;
    name = "clickhouse-${rev}.tar.gz";
    hash = "sha256-ryUjXN8UNGmkZTkqNHotB4C2E1MHZhx2teqXrlp5ySQ=";
    postFetch = ''
      # delete files that make the source too big
      rm -rf $out/contrib/llvm-project/llvm/test
      rm -rf $out/contrib/llvm-project/clang/test
      rm -rf $out/contrib/croaring/benchmarks

      # fix case insensitivity on macos https://github.com/NixOS/nixpkgs/issues/39308
      rm -rf $out/contrib/sysroot/linux-*
      rm -rf $out/contrib/liburing/man

      # compress to not exceed the 2GB output limit
      # try to make a deterministic tarball
      tar -I 'gzip -n' \
        --sort=name \
        --mtime=1970-01-01 \
        --owner=0 --group=0 \
        --numeric-owner --mode=go=rX,u+rw,a-s \
        --transform='s@^@source/@S' \
        -cf temp  -C "$out" .
      rm -r "$out"
      mv temp "$out"
    '';
  };

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    ninja
    python3
    perl
  ] ++ lib.optionals stdenv.isx86_64 [
    yasm
  ] ++ lib.optionals stdenv.isDarwin [
    llvmPackages.bintools
    findutils
    darwin.bootstrap_cmds
  ] ++ lib.optionals rustSupport [
    rustc
    cargo
    rustPlatform.cargoSetupHook
  ];

  # their vendored version is too old and missing this patch: https://github.com/corrosion-rs/corrosion/pull/205
  corrosionSrc = if rustSupport then fetchFromGitHub {
    owner = "corrosion-rs";
    repo = "corrosion";
    rev = "v0.3.5";
    hash = "sha256-r/jrck4RiQynH1+Hx4GyIHpw/Kkr8dHe1+vTHg+fdRs=";
  } else null;
  corrosionDeps = if rustSupport then rustPlatform.fetchCargoTarball {
    src = corrosionSrc;
    name = "corrosion-deps";
    preBuild = "cd generator";
    hash = "sha256-dhUgpwSjE9NZ2mCkhGiydI51LIOClA5wwk1O3mnnbM8=";
  } else null;
  blake3Deps = if rustSupport then rustPlatform.fetchCargoTarball {
    inherit src;
    name = "blake3-deps";
    preBuild = "cd rust/BLAKE3";
    hash = "sha256-lDMmmsyjEbTfI5NgTgT4+8QQrcUE/oUWfFgj1i19W0Q=";
  } else null;
  skimDeps = if rustSupport then rustPlatform.fetchCargoTarball {
    inherit src;
    name = "skim-deps";
    preBuild = "cd rust/skim";
    hash = "sha256-gEWB+U8QrM0yYyMXpwocszJZgOemdTlbSzKNkS0NbPk=";
  } else null;

  dontCargoSetupPostUnpack = true;
  postUnpack = lib.optionalString rustSupport ''
    pushd source

    rm -rf contrib/corrosion
    cp -r --no-preserve=mode $corrosionSrc contrib/corrosion

    pushd contrib/corrosion/generator
    cargoDeps="$corrosionDeps" cargoSetupPostUnpackHook
    corrosionDepsCopy="$cargoDepsCopy"
    popd

    pushd rust/BLAKE3
    cargoDeps="$blake3Deps" cargoSetupPostUnpackHook
    blake3DepsCopy="$cargoDepsCopy"
    popd

    pushd rust/skim
    cargoDeps="$skimDeps" cargoSetupPostUnpackHook
    skimDepsCopy="$cargoDepsCopy"
    popd

    popd
  '';
=======
{ lib, stdenv, fetchFromGitHub, cmake, libtool, llvm-bintools, ninja
, boost, brotli, capnproto, cctz, clang-unwrapped, double-conversion
, icu, jemalloc, libcpuid, libxml2, lld, llvm, lz4, libmysqlclient, openssl, perl
, poco, protobuf, python3, rapidjson, re2, rdkafka, readline, sparsehash, unixODBC
, xxHash, zstd
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "clickhouse";
  version = "22.8.16.32";

  broken = stdenv.buildPlatform.is32bit; # not supposed to work on 32-bit https://github.com/ClickHouse/ClickHouse/pull/23959#issuecomment-835343685

  src = fetchFromGitHub {
    owner  = "ClickHouse";
    repo   = "ClickHouse";
    rev    = "v${version}-lts";
    fetchSubmodules = true;
    sha256 = "sha256-LArHbsu2iaEP+GrCxdTrfpGDDfwcg1mlvbAceXNZyz8=";
  };

  nativeBuildInputs = [ cmake libtool llvm-bintools ninja ];
  buildInputs = [
    boost brotli capnproto cctz clang-unwrapped double-conversion
    icu jemalloc libxml2 lld llvm lz4 libmysqlclient openssl perl
    poco protobuf python3 rapidjson re2 rdkafka readline sparsehash unixODBC
    xxHash zstd
  ] ++ lib.optional stdenv.hostPlatform.isx86 libcpuid;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    patchShebangs src/

    substituteInPlace src/Storages/System/StorageSystemLicenses.sh \
      --replace 'git rev-parse --show-toplevel' '$src'
    substituteInPlace utils/check-style/check-duplicate-includes.sh \
      --replace 'git rev-parse --show-toplevel' '$src'
    substituteInPlace utils/check-style/check-ungrouped-includes.sh \
      --replace 'git rev-parse --show-toplevel' '$src'
    substituteInPlace utils/list-licenses/list-licenses.sh \
      --replace 'git rev-parse --show-toplevel' '$src'
    substituteInPlace utils/check-style/check-style \
      --replace 'git rev-parse --show-toplevel' '$src'
<<<<<<< HEAD
  '' + lib.optionalString stdenv.isDarwin ''
    sed -i 's|gfind|find|' cmake/tools.cmake
    sed -i 's|ggrep|grep|' cmake/tools.cmake
  '' + lib.optionalString rustSupport ''

    pushd contrib/corrosion/generator
    cargoDepsCopy="$corrosionDepsCopy" cargoSetupPostPatchHook
    popd

    pushd rust/BLAKE3
    cargoDepsCopy="$blake3DepsCopy" cargoSetupPostPatchHook
    popd

    pushd rust/skim
    cargoDepsCopy="$skimDepsCopy" cargoSetupPostPatchHook
    popd

    cargoSetupPostPatchHook() { true; }
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  cmakeFlags = [
    "-DENABLE_TESTS=OFF"
<<<<<<< HEAD
    "-DCOMPILER_CACHE=disabled"
    "-DENABLE_EMBEDDED_COMPILER=ON"
  ];

  # https://github.com/ClickHouse/ClickHouse/issues/49988
  hardeningDisable = [ "fortify" ];

=======
    "-DENABLE_CCACHE=0"
    "-DENABLE_EMBEDDED_COMPILER=ON"
    "-USE_INTERNAL_LLVM_LIBRARY=OFF"
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postInstall = ''
    rm -rf $out/share/clickhouse-test

    sed -i -e '\!<log>/var/log/clickhouse-server/clickhouse-server\.log</log>!d' \
      $out/etc/clickhouse-server/config.xml
    substituteInPlace $out/etc/clickhouse-server/config.xml \
      --replace "<errorlog>/var/log/clickhouse-server/clickhouse-server.err.log</errorlog>" "<console>1</console>"
    substituteInPlace $out/etc/clickhouse-server/config.xml \
      --replace "<level>trace</level>" "<level>warning</level>"
  '';

<<<<<<< HEAD
=======
  hardeningDisable = [ "format" ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # Builds in 7+h with 2 cores, and ~20m with a big-parallel builder.
  requiredSystemFeatures = [ "big-parallel" ];

  passthru.tests.clickhouse = nixosTests.clickhouse;

  meta = with lib; {
    homepage = "https://clickhouse.com";
    description = "Column-oriented database management system";
    license = licenses.asl20;
    maintainers = with maintainers; [ orivej ];
<<<<<<< HEAD

    # not supposed to work on 32-bit https://github.com/ClickHouse/ClickHouse/pull/23959#issuecomment-835343685
    platforms = lib.filter (x: (lib.systems.elaborate x).is64bit) (platforms.linux ++ platforms.darwin);
    broken = stdenv.buildPlatform != stdenv.hostPlatform;
=======
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
