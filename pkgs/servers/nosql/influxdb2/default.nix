{
  buildGoModule,
  fetchFromGitHub,
  fetchurl,
  fetchpatch,
  go-bindata,
  lib,
  perl,
  pkg-config,
  rustPlatform,
  stdenv,
  libiconv,
  nixosTests,
}:

let
  version = "2.7.11";
  ui_version = "OSS-v2.7.10";
  libflux_version = "0.195.2";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb";
    rev = "v${version}";
    hash = "sha256-vqlIPYNP1Rta0aKhazflxr9BvyD1vLixJvRVJwwTPQ8=";
  };

  ui = fetchurl {
    url = "https://github.com/influxdata/ui/releases/download/${ui_version}/build.tar.gz";
    hash = "sha256-dnzYWr68O977jZ3YHlX4ywODzLbnOID743rH2IxP+IQ=";
  };

  flux = rustPlatform.buildRustPackage {
    pname = "libflux";
    version = libflux_version;
    src = fetchFromGitHub {
      owner = "influxdata";
      repo = "flux";
      rev = "v${libflux_version}";
      hash = "sha256-PNI3FpaDjkNEfGX78LRXBR+YUvr62icLMvjUux1XVOY=";
    };
    patches = [
      (fetchpatch {
        name = "fix: add missing explicit lifetime for rust 1.83 build";
        url = "https://github.com/influxdata/flux/commit/8e8f0936bb800f67b4fc406fd69b123aeb2e5fe2.patch";
        stripLen = 2;
        extraPrefix = "";
        excludes = [
          "go/libflux/buildinfo.gen.go"
        ];
        hash = "sha256-KCzJvz91EvfaihrbQPHKd2rikL7wIxxJrjSR+BrcH38=";
      })
    ];
    # Don't fail on missing code documentation
    postPatch = ''
      substituteInPlace flux-core/src/lib.rs \
        --replace-fail "deny(warnings, missing_docs))]" "deny(warnings))]"
    '';
    sourceRoot = "${src.name}/libflux";
    useFetchCargoVendor = true;
    cargoHash = "sha256-wJVvpjaBUae3FK3lQaQov4t0UEsH86tB8B8bsSFGGBU=";
    nativeBuildInputs = [ rustPlatform.bindgenHook ];
    buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;
    pkgcfg = ''
      Name: flux
      Version: ${libflux_version}
      Description: Library for the InfluxData Flux engine
      Cflags: -I/out/include
      Libs: -L/out/lib -lflux -lpthread
    '';
    passAsFile = [ "pkgcfg" ];
    postInstall =
      ''
        mkdir -p $out/include $out/pkgconfig
        cp -r $NIX_BUILD_TOP/source/libflux/include/influxdata $out/include
        substitute $pkgcfgPath $out/pkgconfig/flux.pc \
          --replace /out $out
      ''
      + lib.optionalString stdenv.hostPlatform.isDarwin ''
        install_name_tool -id $out/lib/libflux.dylib $out/lib/libflux.dylib
      '';
  };
in
buildGoModule {
  pname = "influxdb";
  version = version;
  inherit src;

  nativeBuildInputs = [
    go-bindata
    pkg-config
    perl
  ];

  vendorHash = "sha256-BfwJu0IVQdhd2yFZxtou3lUavTxZ2sJuhK5IxryXwRc=";
  subPackages = [
    "cmd/influxd"
    "cmd/telemetryd"
  ];

  PKG_CONFIG_PATH = "${flux}/pkgconfig";

  postPatch = ''
    # use go-bindata from environment
    substituteInPlace static/static.go \
      --replace 'go run github.com/kevinburke/go-bindata/' ""
  '';

  # Check that libflux and the UI are at the right version, and embed
  # the UI assets into the Go source tree.
  preBuild = ''
    (
      flux_ver=$(grep github.com/influxdata/flux go.mod | awk '{print $2}')
      if [ "$flux_ver" != "v${libflux_version}" ]; then
        echo "go.mod wants libflux $flux_ver, but nix derivation provides ${libflux_version}"
        exit 1
      fi

      ui_ver=$(egrep 'UI_RELEASE=".*"' scripts/fetch-ui-assets.sh | cut -d'"' -f2)
      if [ "$ui_ver" != "${ui_version}" ]; then
        echo "scripts/fetch-ui-assets.sh wants UI $ui_ver, but nix derivation provides ${ui_version}"
        exit 1
      fi
    )

    mkdir -p static/data
    tar -xzf ${ui} -C static/data
    pushd static
    go generate
    popd
  '';

  tags = [ "assets" ];

  ldflags = [
    "-X main.commit=v${version}"
    "-X main.version=${version}"
  ];

  passthru.tests = {
    inherit (nixosTests) influxdb2;
  };

  meta = with lib; {
    description = "Open-source distributed time series database";
    license = licenses.mit;
    homepage = "https://influxdata.com/";
    maintainers = with maintainers; [ abbradar ];
  };
}
