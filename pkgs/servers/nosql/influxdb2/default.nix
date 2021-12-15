{ buildGoModule
, buildGoPackage
, fetchFromGitHub
, fetchurl
, go-bindata
, lib
, llvmPackages
, pkg-config
, rustPlatform
, stdenv
, libiconv
}:

let
  version = "2.1.1";
  shorthash = "657e1839de"; # git rev-parse --short HEAD with the release checked out
  libflux_version = "0.139.0";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb";
    rev = "v${version}";
    sha256 = "sha256-wf01DhB1ampZuWPkHUEOf3KJK4GjeOAPL3LG2+g4NGY=";
  };

  ui = fetchurl {
    url = "https://github.com/influxdata/ui/releases/download/OSS-${version}/build.tar.gz";
    # https://github.com/influxdata/ui/releases/download/OSS-${version}/sha256.txt
    sha256 = "25ec479b257545bbea5c2191301e6de36ee3f0fa02078de02b05735ebc3cd93b";
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

  vendorSha256 = "sha256-96cENiUcoazQyss6ocYzY9NmUpzzU3s+fAf3AHyLYEg=";
  subPackages = [ "cmd/influxd" "cmd/telemetryd" ];

  PKG_CONFIG_PATH = "${flux}/pkgconfig";
  # We have to run a bunch of go:generate commands to embed the UI
  # assets into the source code. Ideally we'd run `make generate`, but
  # that ends up running a ton of non-hermetic stuff. Instead, we find
  # the relevant go:generate directives, and run them by hand without
  # breaking hermeticity.
  preBuild = ''
    mkdir -p static/data
    tar -xzf ${ui} -C static/data

    grep -RI -e 'go:generate.*go-bindata' | cut -f1 -d: | while read -r filename; do
      sed -i -e 's/go:generate.*go-bindata/go:generate go-bindata/' $filename
      pushd $(dirname $filename)
      go generate
      popd
    done
  '';

  tags = [ "assets" ];

  ldflags = [ "-X main.commit=${shorthash}" "-X main.version=${version}" ];

  meta = with lib; {
    description = "An open-source distributed time series database";
    license = licenses.mit;
    homepage = "https://influxdata.com/";
    maintainers = with maintainers; [ danderson ];
  };
}
