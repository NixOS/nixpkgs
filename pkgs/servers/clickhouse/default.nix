{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, python3
, perl
, yasm
, nixosTests

# currently for BLAKE3 hash function
, rustSupport ? true

, corrosion
, rustc
, cargo
, rustPlatform
}:

stdenv.mkDerivation rec {
  pname = "clickhouse";
  version = "23.3.2.37";

  src = fetchFromGitHub rec {
    owner = "ClickHouse";
    repo = "ClickHouse";
    rev = "v${version}-lts";
    fetchSubmodules = true;
    hash = "sha256-G/5KZ4vd9w5g0yB6bzyM8VX3l32Di+a6Ll87NK3GOrg=";
    name = "clickhouse-${rev}.tar.gz";
    postFetch = ''
      # compress to not exceed the 4GB output limit
      # try to make a deterministic tarball
      tar -I 'gzip -n' \
        --sort=name \
        --mtime=1970-01-01 \
        --owner=root --group=root \
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
  ] ++ lib.optionals rustSupport [
    rustc
    cargo
    rustPlatform.cargoSetupHook
  ];

  corrosionDeps = if rustSupport then corrosion.cargoDeps else null;
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

    # their vendored version is too old and missing this patch: https://github.com/corrosion-rs/corrosion/pull/205
    rm -rf contrib/corrosion
    cp -r --no-preserve=mode ${corrosion.src} contrib/corrosion

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
  '';

  cmakeFlags = [
    "-DENABLE_TESTS=OFF"
    "-DENABLE_CCACHE=0"
    "-DENABLE_EMBEDDED_COMPILER=ON"
    "-DWERROR=OFF"
  ];

  postInstall = ''
    rm -rf $out/share/clickhouse-test

    sed -i -e '\!<log>/var/log/clickhouse-server/clickhouse-server\.log</log>!d' \
      $out/etc/clickhouse-server/config.xml
    substituteInPlace $out/etc/clickhouse-server/config.xml \
      --replace "<errorlog>/var/log/clickhouse-server/clickhouse-server.err.log</errorlog>" "<console>1</console>"
    substituteInPlace $out/etc/clickhouse-server/config.xml \
      --replace "<level>trace</level>" "<level>warning</level>"
  '';

  # Builds in 7+h with 2 cores, and ~20m with a big-parallel builder.
  requiredSystemFeatures = [ "big-parallel" ];

  passthru.tests.clickhouse = nixosTests.clickhouse;

  meta = with lib; {
    homepage = "https://clickhouse.com";
    description = "Column-oriented database management system";
    license = licenses.asl20;
    maintainers = with maintainers; [ orivej ];

    # not supposed to work on 32-bit https://github.com/ClickHouse/ClickHouse/pull/23959#issuecomment-835343685
    platforms = lib.filter (x: (lib.systems.elaborate x).is64bit) platforms.linux;
    broken = stdenv.buildPlatform != stdenv.hostPlatform;
  };
}
