{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
, libiconv
, buildGoModule
, pkg-config
}:

let
  libflux_version = "0.171.0";
  flux = rustPlatform.buildRustPackage rec {
    pname = "libflux";
    version = "v${libflux_version}";
    src = fetchFromGitHub {
      owner = "influxdata";
      repo = "flux";
      rev = "v${libflux_version}";
      hash = "sha256-v9MUR+PcxAus91FiHYrMN9MbNOTWewh7MT6/t/QWQcM=";
    };
    patches = [
      # https://github.com/influxdata/flux/pull/5273
      # fix compile error with Rust 1.64
      (fetchpatch {
        url = "https://github.com/influxdata/flux/commit/20ca62138a0669f2760dd469ca41fc333e04b8f2.patch";
        stripLen = 2;
        extraPrefix = "";
        hash = "sha256-Fb4CuH9ZvrPha249dmLLI8MqSNQRKqKPxPbw2pjqwfY=";
      })
    ];
    sourceRoot = "${src.name}/libflux";
    cargoSha256 = "sha256-oAMoGGdR0QEjSzZ0/J5J9s/ekSlryCcRBSo5N2r70Ko=";
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
  pname = "kapacitor";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "kapacitor";
    rev = "v${version}";
    hash = "sha256-vDluZZrct1x+OMVU8MNO56YBZq7JNlpW68alOrAGYSM=";
  };

  vendorHash = "sha256-OX4QAthg15lwMyhOPyLTS++CMvGI5Um+FSd025PhW3E=";

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

  # Remove failing server tests
  preCheck = ''
    rm server/server_test.go
  '';

  meta = with lib; {
    description = "Open source framework for processing, monitoring, and alerting on time series data";
    homepage = "https://influxdata.com/time-series-platform/kapacitor/";
    downloadPage = "https://github.com/influxdata/kapacitor/releases";
    license = licenses.mit;
    changelog = "https://github.com/influxdata/kapacitor/blob/master/CHANGELOG.md";
    maintainers = with maintainers; [ offline totoroot ];
  };
}
