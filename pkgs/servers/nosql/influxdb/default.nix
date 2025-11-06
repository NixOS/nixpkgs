{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  rustPlatform,
  libiconv,
  nixosTests,
}:

let
  libflux_version = "0.196.1";

  # This is copied from influxdb2 with the required flux version
  flux = rustPlatform.buildRustPackage rec {
    pname = "libflux";
    version = libflux_version;
    src = fetchFromGitHub {
      owner = "influxdata";
      repo = "flux";
      tag = "v${libflux_version}";
      hash = "sha256-935aN2SxfNZvpG90rXuqZ2OTpSGLgiBDbZsBoG0WUvU=";
    };
    patches = [
      # https://github.com/influxdata/flux/pull/5542
      ../influxdb2/fix-unsigned-char.patch
    ];
    # Don't fail on missing code documentation and allow dead_code/lifetime warnings
    postPatch = ''
      substituteInPlace flux-core/src/lib.rs \
        --replace-fail "deny(warnings, missing_docs))]" "deny(warnings), allow(dead_code, mismatched_lifetime_syntaxes))]"
    '';
    sourceRoot = "${src.name}/libflux";

    cargoHash = "sha256-A6j/lb47Ob+Po8r1yvqBXDVP0Hf7cNz8WFZqiVUJj+Y=";
    nativeBuildInputs = [ rustPlatform.bindgenHook ];
    buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;
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
        --replace-fail /out $out
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      install_name_tool -id $out/lib/libflux.dylib $out/lib/libflux.dylib
    '';
  };
in
buildGoModule rec {
  pname = "influxdb";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb";
    rev = "v${version}";
    hash = "sha256-jSv3zzU/jIqALF9mb4gV7zyQvm8pIwJU6Y4ADBlpVOE=";
  };

  vendorHash = "sha256-tPw/1vkUTwmRHrnENDG3NJTV6RplI4pCP6GueRT8dbc=";

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
