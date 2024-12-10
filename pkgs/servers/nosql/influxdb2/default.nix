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
  version = "2.7.1";
  ui_version = "OSS-v${version}";
  libflux_version = "0.193.0";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb";
    rev = "v${version}";
    hash = "sha256-JWu4V2k8ItbzBa421EtzgMVlDznoDdGjIhfDSaZ0j6c=";
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
      hash = "sha256-gx6vnGOFu35wasLl7X/73eDsE0/50cAzjmBjZ+H2Ne4=";
    };
    patches = [
      # Fix build with recent rust versions
      (fetchpatch {
        url = "https://github.com/influxdata/flux/commit/6dc8054cfeec4b65b5c7ae786d633240868b8589.patch";
        stripLen = 2;
        extraPrefix = "";
        excludes = [ "rust-toolchain.toml" ];
        hash = "sha256-w3z+Z26Xhy9TNICyNhc8XiWNSpdLA23ADI4K/AOMYhg=";
      })
      ./no-deny-warnings.patch
    ];
    sourceRoot = "${src.name}/libflux";
    cargoSha256 = "sha256-MoI5nxLGA/3pduZ+vgmSG3lm3Nx58SP+6WXQl2pX9Lc=";
    nativeBuildInputs = [ rustPlatform.bindgenHook ];
    buildInputs = lib.optional stdenv.isDarwin libiconv;
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
      + lib.optionalString stdenv.isDarwin ''
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

  vendorHash = "sha256-5b1WRq3JndkOkKBhMzGZnSyBDY5Lk0UGe/WGHQJp0CQ=";
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
    description = "An open-source distributed time series database";
    license = licenses.mit;
    homepage = "https://influxdata.com/";
    maintainers = with maintainers; [ abbradar ];
  };
}
