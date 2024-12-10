{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchzip,
  rustPlatform,
  bootstrap_cmds,
  DiskArbitration,
  Foundation,
  cmake,
  libiconv,
  openssl,
  perl,
  pkg-config,
  protobuf,
  libclang,
  rdkafka,
}:

let
  fetchNpmPackage =
    {
      name,
      version,
      hash,
      js_prod_file,
      js_dev_file,
      ...
    }@args:
    let
      package = fetchzip {
        url = "https://registry.npmjs.org/${name}/-/${baseNameOf name}-${version}.tgz";
        inherit hash;
      };

      files =
        with args;
        [
          {
            src = js_prod_file;
            dst = "./src/environmentd/src/http/static/js/vendor/${name}.js";
          }
          {
            src = js_prod_file;
            dst = "./src/prof-http/src/http/static/js/vendor/${name}.js";
          }
          {
            src = js_dev_file;
            dst = "./src/environmentd/src/http/static-dev/js/vendor/${name}.js";
          }
          {
            src = js_dev_file;
            dst = "./src/prof-http/src/http/static-dev/js/vendor/${name}.js";
          }
        ]
        ++ lib.optionals (args ? css_file) [
          {
            src = css_file;
            dst = "./src/environmentd/src/http/static/css/vendor/${name}.css";
          }
          {
            src = css_file;
            dst = "./src/prof-http/src/http/static/css/vendor/${name}.css";
          }
        ]
        ++ lib.optionals (args ? extra_file) [
          {
            src = extra_file.src;
            dst = "./src/environmentd/src/http/static/${extra_file.dst}";
          }
          {
            src = extra_file.src;
            dst = "./src/prof-http/src/http/static/${extra_file.dst}";
          }
        ];
    in
    lib.concatStringsSep "\n" (
      lib.forEach files (
        { src, dst }:
        ''
          mkdir -p "${dirOf dst}"
          cp "${package}/${src}" "${dst}"
        ''
      )
    );

  npmPackages = import ./npm_deps.nix;
in
rustPlatform.buildRustPackage rec {
  pname = "materialize";
  version = "0.84.2";
  MZ_DEV_BUILD_SHA = "9f8cf75b461d288335cb6a7a73aaa670bab4a466";

  src = fetchFromGitHub {
    owner = "MaterializeInc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+cvTCiTbuaPYPIyDxQlMWdJA5/6cbMoiTcSmjj5KPjs=";
    fetchSubmodules = true;
  };

  postPatch = ''
    ${lib.concatStringsSep "\n" (map fetchNpmPackage npmPackages)}
    substituteInPlace ./misc/dist/materialized.service \
      --replace /usr/bin $out/bin \
      --replace _Materialize root
    substituteInPlace ./src/catalog/build.rs \
      --replace '&[ ' '&["."'
  '';

  # needed for internal protobuf c wrapper library
  env.PROTOC = "${protobuf}/bin/protoc";
  env.PROTOC_INCLUDE = "${protobuf}/include";
  # needed to dynamically link rdkafka
  env.CARGO_FEATURE_DYNAMIC_LINKING = 1;

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "columnation-0.1.0" = "sha256-VRDQqIVLayEnMHeth4cjsS/FYah3B3mwYEGnv8jpKs8=";
      "differential-dataflow-0.12.0" = "sha256-cEmtDXOZSy4rDFZ7gCd7lx6wH+m1S9vphjb+wO4MSAM=";
      "eventsource-client-0.11.0" = "sha256-FeEWV2yy1et5mna0TyAnakXlcIR42Aq97Lfjjlom8T0=";
      "launchdarkly-server-sdk-1.0.0" = "sha256-fSWiV9mNf5WBkWDNckiUR3URQ8lJ4GZURxbYO/753sU=";
      "librocksdb-sys-0.11.0+8.3.2" = "sha256-bnAvH2z9n26MYFhTN/+Yz+7lEdNKKmHJOoHkxTdZGvw=";
      "openssh-0.9.9" = "sha256-2jaQN6PhavUtlWwqCn2VXEg213uj7BQ+FIrhnL3rb8Q=";
      "postgres-0.19.5" = "sha256-i0mURHTCMrgaW1DD1CihWMdZ3zoNI14dCpq/ja8RW9E=";
      "postgres_array-0.11.0" = "sha256-ealgPVExRIFUt0QVao8H7Q7u/PTuCbpGrk6Tm5jVwZ0=";
      "proptest-1.0.0" = "sha256-sJbPQIVeHZZiRXssRpJWRbD9l8QnfwVcpGu6knjAe5o=";
      "rdkafka-0.29.0" = "sha256-48CMvJ4PoVfKyiNMSpCGBtj36j2CF1E8a/QQ/urfiPc=";
      "reqwest-middleware-0.2.3" = "sha256-zzlQycH5dmgM8ew1gy8m5r6Q2ib7LXnUeX69M3ih+sY=";
      "serde-value-0.7.0" = "sha256-ewEYsf1+9MmLuSm5KbO326ngGB79i00lAp2NMHuuxw8=";
      "timely-0.12.0" = "sha256-wJtHJ9ygPVusN5Io8SjZGo1r7lcrrcauESSC+9038AU=";
      "tonic-build-0.9.2" = "sha256-cGvHjgmdr3NU1phwUfMvEE6uU12fOlhTlL2LoWeOO4I=";
      "tracing-opentelemetry-0.22.0" = "sha256-mawDGrue/e3dPYVG0ANs9nZ+xmQyd1YTWH8QmE6VD0U=";
    };
  };

  nativeBuildInputs =
    [
      cmake
      perl
      pkg-config
      rustPlatform.bindgenHook
    ]
    # Provides the mig command used by the krb5-src build script
    ++ lib.optional stdenv.hostPlatform.isDarwin bootstrap_cmds;

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  buildInputs =
    [
      openssl
      rdkafka
      libclang
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
      DiskArbitration
      Foundation
    ];

  # the check phase requires linking with rocksdb which can be a problem since
  # the rust rocksdb crate is not updated very often.
  doCheck = false;

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

  cargoBuildFlags = [ "--bin environmentd --bin clusterd" ];

  postInstall = ''
    install --mode=444 -D ./misc/dist/materialized.service $out/etc/systemd/system/materialized.service
  '';

  meta = with lib; {
    homepage = "https://materialize.com";
    description = "Streaming SQL materialized view engine for real-time applications";
    license = licenses.bsl11;
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
    ];
    maintainers = [ maintainers.petrosagg ];
  };
}
