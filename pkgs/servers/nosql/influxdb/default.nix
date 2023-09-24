{ lib, buildGoModule, fetchFromGitHub, stdenv, pkg-config, rustPlatform, libiconv, fetchpatch, nixosTests }:

let
  libflux_version = "0.170.1";

  # This is copied from influxdb2 with flux version matching the needed by thi
  flux = rustPlatform.buildRustPackage rec {
    pname = "libflux";
    version = "v${libflux_version}";
    src = fetchFromGitHub {
      owner = "influxdata";
      repo = "flux";
      rev = "v${libflux_version}";
      sha256 = "sha256-P3SpleOVbL+nGWdscwjj9yWqRdck/9JsAwuJtGOO7N8=";
    };
    patches = [
      # https://github.com/influxdata/flux/pull/5273
      # fix compile error with Rust 1.64
      (fetchpatch {
        url = "https://github.com/influxdata/flux/commit/20ca62138a0669f2760dd469ca41fc333e04b8f2.patch";
        stripLen = 2;
        extraPrefix = "";
        sha256 = "sha256-Fb4CuH9ZvrPha249dmLLI8MqSNQRKqKPxPbw2pjqwfY=";
      })
    ];
    sourceRoot = "${src.name}/libflux";
    cargoSha256 = "sha256-kYiZ5ZRiFHRf1RQeeUGjIhnEkTvhNSZ0t4tidpRIDyk=";
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
    postInstall = ''
      mkdir -p $out/include $out/pkgconfig
      cp -r $NIX_BUILD_TOP/source/libflux/include/influxdata $out/include
      substitute $pkgcfgPath $out/pkgconfig/flux.pc \
        --replace /out $out
    '' + lib.optionalString stdenv.isDarwin ''
      install_name_tool -id $out/lib/libflux.dylib $out/lib/libflux.dylib
    '';
  };
in
buildGoModule rec {
  pname = "influxdb";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BMHR9EdYC+8oA0he7emzBRmNnHn15nO/5NqsLcr+R0k=";
  };

  vendorHash = "sha256-AY04cmfg7vbrWR4+LBuCFYqBgQJBXlPpO+2oj0qqjM4=";

  nativeBuildInputs = [ pkg-config ];

  PKG_CONFIG_PATH = "${flux}/pkgconfig";

  # Check that libflux is at the right version
  preBuild = ''
    flux_ver=$(grep github.com/influxdata/flux go.mod | awk '{print $2}')
    if [ "$flux_ver" != "v${libflux_version}" ]; then
      echo "go.mod wants libflux $flux_ver, but nix derivation provides ${libflux_version}"
      exit 1
    fi
  '';

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  excludedPackages = "test";

  passthru.tests = { inherit (nixosTests) influxdb; };

  meta = with lib; {
    description = "An open-source distributed time series database";
    license = licenses.mit;
    homepage = "https://influxdata.com/";
    maintainers = with maintainers; [ offline zimbatm ];
  };
}
