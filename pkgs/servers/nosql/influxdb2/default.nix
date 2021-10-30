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

# Note for maintainers: use ./update-influxdb2.sh to update the Yarn
# dependencies nix expression.

let
  version = "2.0.8";
  shorthash = "e91d41810f"; # git rev-parse HEAD with 2.0.8 checked out
  libflux_version = "0.124.0";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb";
    rev = "v${version}";
    sha256 = "0hbinnja13xr9ziyynjsnsbrxmyrvag7xdgfwq2ya28g07lw5wgq";
  };

  ui = fetchurl {
    url = "https://github.com/influxdata/ui/releases/download/OSS-v${version}/build.tar.gz";
    # https://github.com/influxdata/ui/releases/download/OSS-v${version}/sha256.txt
    sha256 = "94965ae999a1098c26128141fbb849be3da9a723d509118eb6e0db4384ee01fc";
  };

  flux = rustPlatform.buildRustPackage {
    pname = "libflux";
    version = "v${libflux_version}";
    src = fetchFromGitHub {
      owner = "influxdata";
      repo = "flux";
      rev = "v${libflux_version}";
      sha256 = "1g1qilfzxqbbjbfvgkf7k7spcnhzvlmrqacpqdl05418ywkp3v29";
    };
    sourceRoot = "source/libflux";
    cargoSha256 = "0farcjwnwwgfvcgbs5r6vsdrsiwq2mp82sjxkqb1pzqfls4ixcxj";
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

  vendorSha256 = "1kar88vlm6px7smlnajpyf8qx6d481xk979qafpfb1xy8931781m";
  subPackages = [ "cmd/influxd" "cmd/influx" ];

  PKG_CONFIG_PATH = "${flux}/pkgconfig";
  # We have to run a bunch of go:generate commands to embed the UI
  # assets into the source code. Ideally we'd run `make generate`, but
  # that ends up running a ton of non-hermetic stuff. Instead, we find
  # the relevant go:generate directives, and run them by hand without
  # breaking hermeticity.
  preBuild = ''
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
