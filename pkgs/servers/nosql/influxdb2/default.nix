{ buildGoModule
, fetchFromGitHub
, fetchurl
, fetchpatch
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
  version = "2.5.1";
  # Despite the name, this is not a rolling release. This is the
  # version of the UI assets for 2.5.1, as specified in
  # scripts/fetch-ui-assets.sh in the 2.5.1 tag of influxdb.
  ui_version = "OSS-2022-09-16";
  libflux_version = "0.188.1";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb";
    rev = "v${version}";
    sha256 = "sha256-AKyuFBja06BuWYliqIGKOb4PIc5G8S9S+cf/dLrEATY=";
  };

  ui = fetchurl {
    url = "https://github.com/influxdata/ui/releases/download/${ui_version}/build.tar.gz";
    sha256 = "sha256-YKDp1jLyo4n+YTeMaWl8dhN4Lr3H8FXV7stJ3p3zFe8=";
  };

  flux = rustPlatform.buildRustPackage {
    pname = "libflux";
    version = "v${libflux_version}";
    src = fetchFromGitHub {
      owner = "influxdata";
      repo = "flux";
      rev = "v${libflux_version}";
      sha256 = "sha256-Xmh7V/o1Gje62kcnTeB9h/fySljhfu+tjbyvryvIGRc=";
    };
    sourceRoot = "source/libflux";
    cargoSha256 = "sha256-9rPW0lgi3lXJARa1KXgSY8LVJsoFjppok5ODGlqYeYw=";
    nativeBuildInputs = [ llvmPackages.libclang ];
    buildInputs = lib.optional stdenv.isDarwin libiconv;
    LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
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
        --replace /out $out
    '' + lib.optionalString stdenv.isDarwin ''
      install_name_tool -id $out/lib/libflux.dylib $out/lib/libflux.dylib
    '';
  };

in buildGoModule {
  pname = "influxdb";
  version = version;
  inherit src;

  nativeBuildInputs = [ go-bindata pkg-config perl ];

  vendorSha256 = "sha256-02x+HsWkng7OnKVSfkQR8LL1Qk42Bdrw0IMtBpS7xQc=";
  subPackages = [ "cmd/influxd" "cmd/telemetryd" ];

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

  ldflags = [ "-X main.commit=v${version}" "-X main.version=${version}" ];

  meta = with lib; {
    description = "An open-source distributed time series database";
    license = licenses.mit;
    homepage = "https://influxdata.com/";
    maintainers = with maintainers; [ abbradar danderson ];
  };
}
