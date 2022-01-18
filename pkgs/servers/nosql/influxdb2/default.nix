{ buildGoModule
, fetchFromGitHub
, fetchurl
, go-bindata
, lib
, llvmPackages
, perl
, pkg-config
, rustPlatform
, stdenv
, libiconv
}:

let
  version = "2.1.1";
  ui_version = "2.1.2";
  libflux_version = "0.139.0";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb";
    rev = "v${version}";
    sha256 = "sha256-wf01DhB1ampZuWPkHUEOf3KJK4GjeOAPL3LG2+g4NGY=";
  };

  ui = fetchurl {
    url = "https://github.com/influxdata/ui/releases/download/OSS-${ui_version}/build.tar.gz";
    sha256 = "sha256-fXjShNJfKN/ZQNQHoX9/Ou4XBrXavCN+rcO+8AMc5Ug=";
  };

  flux = rustPlatform.buildRustPackage {
    pname = "libflux";
    version = "v${libflux_version}";
    src = fetchFromGitHub {
      owner = "influxdata";
      repo = "flux";
      rev = "v${libflux_version}";
      sha256 = "sha256-cELeWZXGVLFoPYfBoBP8NeLBVFIb5o+lWyto42BLyXY=";
    };
    sourceRoot = "source/libflux";
    cargoSha256 = "sha256-wFgawxgqZqoPnOXJD3r5t2n7Y2bTAkBbBxeBtFEF7N4=";
    nativeBuildInputs = [ llvmPackages.libclang ];
    buildInputs = lib.optional stdenv.isDarwin libiconv;
    LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
    pkgcfg = ''
      Name: flux
      Version: ${libflux_version}
      Description: Library for the InfluxData Flux engine
      Cflags: -I/out/include
      Libs: -L/out/lib -lflux -ldl -lpthread
    '';
    passAsFile = [ "pkgcfg" ];
    postInstall = ''
      mkdir -p $out/include $out/pkgconfig
      cp -r $NIX_BUILD_TOP/source/libflux/include/influxdata $out/include
      substitute $pkgcfgPath $out/pkgconfig/flux.pc \
        --replace /out $out
    '' + lib.optionalString stdenv.isDarwin ''
      install_name_tool -id $out/lib/libflux.dylib $out/lib/libflux.dylib
    '';
  };

in buildGoModule {
  pname = "influxdb";
  version = version;
  src = src;

  nativeBuildInputs = [ go-bindata pkg-config ];

  vendorSha256 = "sha256-GVLAzVJzSsC10ZWDZPP8upydwZG21E+zQ6sMKm1lCY0=";
  subPackages = [ "cmd/influxd" "cmd/telemetryd" ];

  PKG_CONFIG_PATH = "${flux}/pkgconfig";
  # Check that libflux and the UI are at the right version, and embed
  # the UI assets into the Go source tree.
  preBuild = ''
    (
      flux_ver=$(grep github.com/influxdata/flux go.mod | awk '{print $2}')
      if [ "$flux_ver" != "v${libflux_version}" ]; then
        echo "go.mod wants libflux $flux_ver, but nix derivation provides ${libflux_version}"
        exit 1
      fi

      ui_ver=$(grep influxdata/ui/releases scripts/fetch-ui-assets.sh | ${perl}/bin/perl -pe 's#.*/OSS-([^/]+)/.*#$1#')
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

  ldflags = [ "-X main.commit=v${version}" "-X main.version=${version}" ];

  meta = with lib; {
    description = "An open-source distributed time series database";
    license = licenses.mit;
    homepage = "https://influxdata.com/";
    maintainers = with maintainers; [ abbradar danderson ];
  };
}
