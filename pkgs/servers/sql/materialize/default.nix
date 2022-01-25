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
  version = "0.15.0";
  MZ_DEV_BUILD_SHA = "f79f63205649d6011822893c5b55396b2bef7b0b";

  src = fetchFromGitHub {
    owner = "MaterializeInc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/A6+0fehBa8XEB8P8QUV5Lsl9Lwfz4FhQLgotvBG1Gw=";
  };

  cargoHash = "sha256-NJvAIy9b39HWJaG860Mlf3WasanUnz+Nq39k4WpddB0=";

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
    # this test is broken on 0.15.0
    # TODO: re-add it in a subsequent release
    "--skip test_threads"
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
