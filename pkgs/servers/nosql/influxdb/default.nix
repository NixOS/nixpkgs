{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  rustPlatform,
  libiconv,
  fetchpatch,
  nixosTests,
}:

let
  libflux_version = "0.194.5";

  # This is copied from influxdb2 with the required flux version
  flux = rustPlatform.buildRustPackage rec {
    pname = "libflux";
    version = "v${libflux_version}";
    src = fetchFromGitHub {
      owner = "influxdata";
      repo = "flux";
      rev = "v${libflux_version}";
      hash = "sha256-XHT/+JMu5q1cPjZT2x/OKEPgxFJcnjrQKqn8w9/Mb3s=";
    };
    patches = [
      # Fix build on Rust 1.78 (included after v0.195.0)
      (fetchpatch {
        name = "fix-build-on-rust-1.78.patch";
        url = "https://github.com/influxdata/flux/commit/68c831c40b396f0274f6a9f97d77707c39970b02.patch";
        stripLen = 2;
        extraPrefix = "";
        excludes = [ ];
        hash = "sha256-6LOTgbOCfETNTmshyXgtDZf9y4t/2iqRuVPkz9dYPHc=";
      })
      ../influxdb2/fix-unsigned-char.patch
    ];
    sourceRoot = "${src.name}/libflux";
    cargoHash = "sha256-O+t4f4P5291BuyARH6Xf3LejMFEQEBv+qKtyjHRhclA=";
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
buildGoModule rec {
  pname = "influxdb";
  version = "1.10.7";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Aibu3yG/D1501Hr2F2qsGvjig14tbEAI+MBfqbxlpg8=";
  };

  vendorHash = "sha256-AA6uj7PgXjC+IK2ZSwRnYpHS4MFScOROO1BpP+s33IU=";

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

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  excludedPackages = "test";

  passthru.tests = {
    inherit (nixosTests) influxdb;
  };

  meta = with lib; {
    description = "Open-source distributed time series database";
    license = licenses.mit;
    homepage = "https://influxdata.com/";
    maintainers = with maintainers; [
      offline
      zimbatm
    ];
  };
}
