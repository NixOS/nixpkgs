{ lib, buildGoModule, fetchFromGitHub, stdenv, pkg-config, rustPlatform, libiconv, fetchpatch, nixosTests }:

let
  libflux_version = "0.188.0";

  # This is copied from influxdb2 with flux version matching the needed by thi
  flux = rustPlatform.buildRustPackage rec {
    pname = "libflux";
    version = "v${libflux_version}";
    src = fetchFromGitHub {
      owner = "influxdata";
      repo = "flux";
      rev = "v${libflux_version}";
      hash = "sha256-4Z6Vfdyh0zimQlE47plSIjTWBYiju0Qu09M+MgMQOL4=";
    };
    patches = [
      # https://github.com/influxdata/flux/pull/5440
      # fix compile error with Rust 1.72.0
      (fetchpatch {
        url = "https://github.com/influxdata/flux/commit/8d1d6c8b485eb7e15b6a5f57762d1f766b17defd.patch";
        stripLen = 2;
        extraPrefix = "";
        hash = "sha256-BDBmGKsC2RWMyObDm7dPwFq/3cVIdBKF8ZVaCL+uftw=";
        includes = [ "flux/src/lib.rs" ];
      })
    ];
    sourceRoot = "${src.name}/libflux";
    cargoHash = "sha256-925U9weBOvMuyApsTOjtQxik3nqT2UpK+DPM64opc7c=";
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
  version = "1.10.5";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FvKGNqy27q6/X2DI/joJXfGVrax6hQcNcx5nJDeSLm0=";
  };

  vendorHash = "sha256-1jeZBVmNOxF5NPlTKg+YRw6VqIIZDcT3snnoMLX3y4g=";

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
    description = "Open-source distributed time series database";
    license = licenses.mit;
    homepage = "https://influxdata.com/";
    maintainers = with maintainers; [ offline zimbatm ];
  };
}
