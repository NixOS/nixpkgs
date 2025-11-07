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
  version = "2.7.12";
  ui_version = "OSS-v2.7.12";
  libflux_version = "0.196.1";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb";
    rev = "v${version}";
    hash = "sha256-FwvcKxCozMqJulDDCFDgp7MYJwMq/9XZ6g2q2lIgFc0=";
  };

  ui = fetchurl {
    url = "https://github.com/influxdata/ui/releases/download/${ui_version}/build.tar.gz";
    hash = "sha256-aC+GYMaxYKkY9GMaeRx22hQ3xi3kfWpaTLC9ajqOaAA=";
  };

  flux = rustPlatform.buildRustPackage {
    pname = "libflux";
    version = libflux_version;
    src = fetchFromGitHub {
      owner = "influxdata";
      repo = "flux";
      rev = "v${libflux_version}";
      hash = "sha256-935aN2SxfNZvpG90rXuqZ2OTpSGLgiBDbZsBoG0WUvU=";
    };
    patches = [
      # https://github.com/influxdata/flux/pull/5542
      ./fix-unsigned-char.patch
    ];
    # Don't fail on warnings
    postPatch = ''
      substituteInPlace flux/Cargo.toml \
        --replace-fail 'default = ["strict", ' 'default = ['
      substituteInPlace flux-core/Cargo.toml \
        --replace-fail 'default = ["strict"]' 'default = []'
    '';
    sourceRoot = "${src.name}/libflux";

    cargoHash = "sha256-A6j/lb47Ob+Po8r1yvqBXDVP0Hf7cNz8WFZqiVUJj+Y=";
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
    postInstall = ''
      mkdir -p $out/include $out/pkgconfig
      cp -r $NIX_BUILD_TOP/source/libflux/include/influxdata $out/include
      substitute $pkgcfgPath $out/pkgconfig/flux.pc \
        --replace-fail /out $out
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

  vendorHash = "sha256-B4w8+UaewujKVr98MFhRh2c6UMOdB+TE/mOT+cy2pHk=";
  subPackages = [
    "cmd/influxd"
    "cmd/telemetryd"
  ];

  PKG_CONFIG_PATH = "${flux}/pkgconfig";

  postPatch = ''
    # use go-bindata from environment
    substituteInPlace static/static.go \
      --replace-fail 'go run github.com/kevinburke/go-bindata/' ""
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
    maintainers = [ ];
  };
}
