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

  useFetchCargoVendor = true;
  cargoHash = "sha256-EHVuwVYPZKaoP3GYtJpYJaKG3CLsy9CWuEmajF4P7Qc=";

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
