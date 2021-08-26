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
  version = "0.8.1";
  rev = "ef996c54db7c9504690b9f230a4a676ae1fb617f";

  src = fetchFromGitHub {
    owner = "MaterializeInc";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lrv0q191rhdqk316557qk2a6b00vrf07j1g63ri6mp8ad1g8gk3";
  };

  cargoSha256 = "0fx7m1ci4zak7sm71kdiaj2l29rlqax15hd424i9yn4aj1bd358b";

  nativeBuildInputs = [ cmake perl pkg-config ]
    # Provides the mig command used by the krb5-src build script
    ++ lib.optional stdenv.isDarwin bootstrap_cmds;

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ libiconv DiskArbitration Foundation ];

  # Skip tests that use the network
  checkFlags = [
    "--exact"
    "--skip test_client"
    "--skip test_client_errors"
    "--skip test_no_block"
    "--skip test_safe_mode"
  ];

  postPatch = ''
    ${lib.concatStringsSep "\n" (map fetchNpmPackage npmPackages)}
    substituteInPlace ./misc/dist/materialized.service \
      --replace /usr/bin $out/bin \
      --replace _Materialize root
  '';

  MZ_DEV_BUILD_SHA = rev;
  cargoBuildFlags = [ "--bin materialized" ];

  postInstall = ''
    install --mode=444 -D ./misc/dist/materialized.service $out/etc/systemd/system/materialized.service
  '';

  meta = with lib; {
    homepage    = "https://materialize.com";
    description = "A streaming SQL materialized view engine for real-time applications";
    license     = licenses.bsl11;
    platforms   = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = [ maintainers.petrosagg ];
  };
}
