{ lib, rustPlatform, pkg-config, cmake, llvmPackages, openssl, fetchFromGitHub
, installShellFiles, stdenv, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "tremor";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "tremor-rs";
    repo = "tremor-runtime";
    rev = "v${version}";
    sha256 = "sha256-FedRwFVc+m25+Elj1Vp/fInbK6DVsUpniw29/dtecWo=";
  };

  cargoSha256 = "sha256-jxXoFOwoBSkn7pv10ctLpD7ko8bokc1ADkB7NQFRC7c=";

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

  cargoBuildFlags = [ "-p tremor-cli" ];

  meta = with lib; {
    description = "Early stage event processing system for unstructured data with rich support for structural pattern matching, filtering and transformation";
    homepage = "https://www.tremor.rs/";
    license = licenses.asl20;
    platforms = platforms.x86_64;
    maintainers = with maintainers; [ humancalico ];
  };
}
