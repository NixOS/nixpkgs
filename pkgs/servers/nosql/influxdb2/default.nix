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
  version = "2.7.6";
  ui_version = "OSS-v2.7.1";
  libflux_version = "0.194.5";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb";
    rev = "v${version}";
    hash = "sha256-0gqFUIV0ETdVuVmC+SwoKsO6OkoT/s+qKO1f8fkaZj4=";
  };

  ui = fetchurl {
    url = "https://github.com/influxdata/ui/releases/download/${ui_version}/build.tar.gz";
    hash = "sha256-0k59SKvt9pFt3WSd5PRUThbfbctt2RYtaxaxoyLICm8=";
  };

  flux = rustPlatform.buildRustPackage {
    pname = "libflux";
    version = "v${libflux_version}";
    src = fetchFromGitHub {
      owner = "influxdata";
      repo = "flux";
      rev = "v${libflux_version}";
      hash = "sha256-XHT/+JMu5q1cPjZT2x/OKEPgxFJcnjrQKqn8w9/Mb3s=";
    };
    patches = [
      # Fix build on Rust 1.78 (included after v0.195.0)
      (fetchpatch {
        name = "fix-build-on-rust-1.78.patch";
        url = "https://github.com/influxdata/flux/commit/68c831c40b396f0274f6a9f97d77707c39970b02.patch";
        stripLen = 2;
        extraPrefix = "";
        excludes = [ ];
        hash = "sha256-6LOTgbOCfETNTmshyXgtDZf9y4t/2iqRuVPkz9dYPHc=";
      })
      ./fix-unsigned-char.patch
    ];
    sourceRoot = "${src.name}/libflux";
    cargoHash = "sha256-O+t4f4P5291BuyARH6Xf3LejMFEQEBv+qKtyjHRhclA=";
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

  vendorHash = "sha256-3Vf8BCrOwliXrH+gmZ4RJ1YBEbqL0Szx2prW3ie9CNg=";
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

  passthru.tests = { inherit (nixosTests) influxdb2; };

  meta = with lib; {
    description = "Open-source distributed time series database";
    license = licenses.mit;
    homepage = "https://influxdata.com/";
    maintainers = with maintainers; [ abbradar ];
  };
}
