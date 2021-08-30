{ buildGoModule
, buildGoPackage
, fetchFromGitHub
, go-bindata
, lib
, llvmPackages
, mkYarnPackage
, pkg-config
, rustPlatform
, stdenv
, libiconv
}:

# Note for maintainers: use ./update-influxdb2.sh to update the Yarn
# dependencies nix expression.

let
  version = "2.0.6";
  shorthash = "4db98b4c9a"; # git rev-parse HEAD with 2.0.6 checked out
  libflux_version = "0.115.0";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb";
    rev = "v${version}";
    sha256 = "1x74p87csx4m4cgijk57xs75nikv3bnh7skgnzk30ab1ar13iirw";
  };

  ui = mkYarnPackage {
    src = src;
    packageJSON = ./influx-ui-package.json;
    yarnLock = "${src}/ui/yarn.lock";
    yarnNix = ./influx-ui-yarndeps.nix;
    configurePhase = ''
      cp -r $node_modules ui/node_modules
      rsync -r $node_modules/../deps/influxdb-ui/node_modules/ ui/node_modules
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
      sha256 = "0zplwsk9xidv8l9sqbxqivy6q20ryd31fhrzspn1mjn4i45kkwz1";
    };
    sourceRoot = "source/libflux";
    cargoSha256 = "06gh466q7qkid0vs5scic0qqlz3h81yb00nwn8nwq8ppr5z2ijyq";
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

  vendorSha256 = "03pabm0h9q0v5dfdq9by2l2n32bz9imwalz0aw897vsrfhci0ldf";
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
