{ buildGoModule
, buildGoPackage
, fetchFromGitHub
, go-bindata
, lib
, llvmPackages
, mkYarnPackage
, pkg-config
, rustPlatform
}:

# Note for maintainers: use ./update-influxdb2.sh to update the Yarn
# dependencies nix expression.

let
  version = "2.0.2";
  shorthash = "84496e507a"; # git rev-parse HEAD with 2.0.2 checked out
  libflux_version = "0.95.0";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb";
    rev = "v${version}";
    sha256 = "05s09crqgbyfdck33zwax5l47jpc4wh04yd8zsm658iksdgzpmnn";
  };

  ui = mkYarnPackage {
    src = src;
    packageJSON = ./influx-ui-package.json;
    yarnLock = "${src}/ui/yarn.lock";
    yarnNix = ./influx-ui-yarndeps.nix;
    configurePhase = ''
      cp -r $node_modules ui/node_modules
      rsync -r $node_modules/../deps/chronograf-ui/node_modules/ ui/node_modules
    '';
    INFLUXDB_SHA = shorthash;
    buildPhase = ''
      pushd ui
      yarn build:ci
      popd
    '';
    installPhase = ''
      mv ui/build $out
    '';
    distPhase = "true";
  };

  flux = rustPlatform.buildRustPackage {
    pname = "libflux";
    version = "v${libflux_version}";
    src = fetchFromGitHub {
      owner = "influxdata";
      repo = "flux";
      rev = "v${libflux_version}";
      sha256 = "07jz2nw3zswg9f4p5sb5r4hpg3n4qibjcgs9sk9csns70h5rp9j3";
    };
    sourceRoot = "source/libflux";
    cargoSha256 = "0y5xjkqpaxp9qq1qj39zw3mnvkbbb9g4fa5cli77nhfwz288xx6h";
    nativeBuildInputs = [ llvmPackages.libclang ];
    LIBCLANG_PATH = "${llvmPackages.libclang}/lib";
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
    '';
  };

  # Can't use the nixpkgs version of go-bindata, it's an ancient
  # ancestor of this more modern one.
  bindata = buildGoPackage {
    pname = "go-bindata";
    version = "v3.22.0";
    src = fetchFromGitHub {
      owner = "kevinburke";
      repo = "go-bindata";
      rev = "v3.22.0";
      sha256 = "10dq77dml5jvvq2jkdq81a9yjg7rncq8iw8r84cc3dz6l9hxzj0x";
    };

    goPackagePath = "github.com/kevinburke/go-bindata";
    subPackages = [ "go-bindata" ];
  };
in buildGoModule {
  pname = "influxdb";
  version = version;
  src = src;

  nativeBuildInputs = [ bindata pkg-config ];

  vendorSha256 = "0lviz7l5zbghyfkp0lvlv8ykpak5hhkfal8d7xwvpsm8q3sghc8a";
  subPackages = [ "cmd/influxd" "cmd/influx" ];

  PKG_CONFIG_PATH = "${flux}/pkgconfig";
  # We have to run a bunch of go:generate commands to embed the UI
  # assets into the source code. Ideally we'd run `make generate`, but
  # that ends up running a ton of non-hermetic stuff. Instead, we find
  # the relevant go:generate directives, and run them by hand without
  # breaking hermeticity.
  preBuild = ''
    ln -s ${ui} ui/build
    grep -RI -e 'go:generate.*go-bindata' | cut -f1 -d: | while read -r filename; do
      sed -i -e 's/go:generate.*go-bindata/go:generate go-bindata/' $filename
      pushd $(dirname $filename)
      go generate
      popd
    done
    export buildFlagsArray=(
      -tags="assets"
      -ldflags="-X main.commit=${shorthash} -X main.version=${version}"
    )
  '';

  meta = with lib; {
    description = "An open-source distributed time series database";
    license = licenses.mit;
    homepage = "https://influxdata.com/";
    maintainers = with maintainers; [ danderson ];
  };
}
