{ stdenv
, lib
, fetchFromGitHub
, fetchzip
, rustPlatform
, bootstrap_cmds
, DiskArbitration
, Foundation
, cmake
, libiconv
, openssl
, perl
, pkg-config}:

let
  fetchNpmPackage = {name, version, hash, js_prod_file, js_dev_file, ...} @ args:
  let
    package = fetchzip {
      url = "https://registry.npmjs.org/${name}/-/${baseNameOf name}-${version}.tgz";
      inherit hash;
    };

    static = "./src/materialized/src/http/static";
    cssVendor = "./src/materialized/src/http/static/css/vendor";
    jsProdVendor = "./src/materialized/src/http/static/js/vendor";
    jsDevVendor = "./src/materialized/src/http/static-dev/js/vendor";

    files = with args; [
      { src = js_prod_file; dst = "${jsProdVendor}/${name}.js"; }
      { src = js_dev_file;  dst = "${jsDevVendor}/${name}.js"; }
    ] ++ lib.optional (args ? css_file) { src = css_file; dst = "${cssVendor}/${name}.css"; }
      ++ lib.optional (args ? extra_file) { src = extra_file.src; dst = "${static}/${extra_file.dst}"; };
  in
    lib.concatStringsSep "\n" (lib.forEach files ({src, dst}: ''
      mkdir -p "${dirOf dst}"
      cp "${package}/${src}" "${dst}"
    ''));

  npmPackages = import ./npm_deps.nix;
in
rustPlatform.buildRustPackage rec {
  pname = "materialize";
  version = "0.17.0";
  MZ_DEV_BUILD_SHA = "9f8cf75b461d288335cb6a7a73aaa670bab4a466";

  src = fetchFromGitHub {
    owner = "MaterializeInc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-wKYU5S77VoOX7UA9/d21Puz9NYs/om08eNM69/m3Orc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "criterion-0.3.5" = "sha256-gXhwLw99kC08zxHdY6l5LF5EVzAAFasI4GLnopLwhEU=";
      "differential-dataflow-0.12.0" = "sha256-sDy4502XqCuXqRtwLWuaHSgfX7v9NNochhfpI6n8DrM=";
      "headers-0.3.5" = "sha256-ipxMfuPgoeH2uR4Im/XBdnxT00+LGzTgW7Ed2armYOU=";
      "mzcloud-1.0.0" = "sha256-Nt9YCG+DFCCOMbKaNhOD78WF/z3qB5ymUIp6Wep2A9A=";
      "parquet-format-async-temp-0.2.0" = "sha256-UUQv/90egmwQK0CZCztinEskvWcZ40rKWbJoWYz2oLQ=";
      "postgres-0.19.1" = "sha256-zH7PF4p7wJCSYpuydTL3HPcOjPU9SlTy6IJREOe2l7U=";
      "postgres_array-0.11.0" = "sha256-M1nMsQfxK0ay4JxoPqm2cl4Cp8mVZlVUAfWDhhv9nA4=";
      "prometheus-0.10.0" = "sha256-NTnKt1RGiZ8AxsU8UzhLhpfEi24Pos5kR9g22Mmt444=";
      "protobuf-3.0.0-alpha.2" = "sha256-8gBGQqAtKJelcBCxnDESanlblBLQ1Th7khHxUkDw7To=";
      "pubnub-core-0.1.0" = "sha256-YuGEFaStfrhb0ygjVFm2a2eJla9ABc5ifXKuvJxUvgk=";
      "rdkafka-0.28.0" = "sha256-u2gBTzu+IvXTDvcZGzPaVpSVOgAKhTth7GLwob4urDs=";
      "timely-0.12.0" = "sha256-PHaDRNm7MezXJWhILWJHTeiCWO3iLUp94Z0V2dreCMk=";
    };
  };

  nativeBuildInputs = [ cmake perl pkg-config ]
    # Provides the mig command used by the krb5-src build script
    ++ lib.optional stdenv.isDarwin bootstrap_cmds;

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ libiconv DiskArbitration Foundation ];

  # Skip tests that use the network
  checkFlags = [
    "--exact"
    "--skip test_client"
    "--skip test_client_errors"
    "--skip test_client_all_subjects"
    "--skip test_client_subject_and_references"
    "--skip test_no_block"
    "--skip test_safe_mode"
    "--skip test_tls"
  ];

  postPatch = ''
    ${lib.concatStringsSep "\n" (map fetchNpmPackage npmPackages)}
    substituteInPlace ./misc/dist/materialized.service \
      --replace /usr/bin $out/bin \
      --replace _Materialize root
  '';

  cargoBuildFlags = [ "--bin materialized" ];

  postInstall = ''
    install --mode=444 -D ./misc/dist/materialized.service $out/etc/systemd/system/materialized.service
  '';

  meta = with lib; {
    homepage    = "https://materialize.com";
    description = "A streaming SQL materialized view engine for real-time applications";
    license     = licenses.bsl11;
    platforms   = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" ];
    maintainers = [ maintainers.petrosagg ];
  };
}
