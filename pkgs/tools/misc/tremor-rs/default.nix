{ lib
, rustPlatform
, pkg-config
, cmake
, llvmPackages
, openssl
, fetchFromGitHub
, installShellFiles
, stdenv
, Security
, libiconv
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "tremor";
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "tremor-rs";
    repo = "tremor-runtime";
    rev = "v${version}";
    sha256 = "sha256-+cN+nMDMX4rxjs1VQnSgjBvCsjxxAd13otp9qd21SYo=";
  };

  cargoSha256 = "sha256-MthdQXZPIOOd5A2bJO4p49e74s76M1HruLxLWbvog4I=";

  nativeBuildInputs = [ cmake pkg-config installShellFiles ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Security libiconv ];

  # TODO export TREMOR_PATH($out/lib) variable
  postInstall = ''
    # Copy the standard library to $out/lib
    cp -r ${src}/tremor-script/lib/ $out

    installShellCompletion --cmd tremor \
      --bash <($out/bin/tremor completions bash) \
      --fish <($out/bin/tremor completions fish) \
      --zsh <($out/bin/tremor completions zsh)
  '';

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  # OPENSSL_NO_VENDOR - If set, always find OpenSSL in the system, even if the vendored feature is enabled.
  OPENSSL_NO_VENDOR = 1;

  # needed for internal protobuf c wrapper library
  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  checkFlags = [
    # all try to make a network access
    "--skip=connectors::tests::http::server::https_server_test"
    "--skip=connectors::tests::tcp::client::tls_client"
    "--skip=connectors::tests::udp::udp_no_bind"
    "--skip=connectors::tests::ws::ws_client_bad_config"
    "--skip=connectors::tests::ws::wss_server_binary_routing"
    "--skip=connectors::tests::ws::wss_server_text_routing"
    "--skip=connectors::utils::tls::tests::client_config"
  ];

  cargoBuildFlags = [ "-p tremor-cli" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = ''
      Early stage event processing system for unstructured data with rich
      support for structural pattern matching, filtering and transformation
    '';
    homepage = "https://www.tremor.rs/";
    license = licenses.asl20;
    platforms = platforms.x86_64;
    maintainers = with maintainers; [ humancalico happysalada ];
  };
}
