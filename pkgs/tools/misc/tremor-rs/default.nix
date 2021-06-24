{ lib, rustPlatform, pkg-config, cmake, llvmPackages, openssl, fetchFromGitHub
, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "tremor";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "tremor-rs";
    repo = "tremor-runtime";
    rev = "v${version}";
    sha256 = "19g0ijkclrza6s0qcbwwh3lhlkisy00ffcl0c0d7dfqwrcisgz57";
  };

  cargoSha256 = "1xv205czb2z6qpqi6vslyrx2n21510qqa11i2hwya3jdcc9lkrsd";

  nativeBuildInputs = [ cmake pkg-config installShellFiles ];

  buildInputs = [ openssl ];

  # TODO export TREMOR_PATH($out/lib) variable
  postInstall = ''
    # Copy the standard library to $out/lib
    cp -r ${src}/tremor-script/lib/ $out

    installShellCompletion --cmd tremor \
      --bash <($out/bin/tremor completions bash) \
      --fish <($out/bin/tremor completions fish) \
      --zsh <($out/bin/tremor completions zsh)
  '';

  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  # OPENSSL_NO_VENDOR - If set, always find OpenSSL in the system, even if the vendored feature is enabled.
  OPENSSL_NO_VENDOR = 1;

  cargoBuildFlags = [ "-p tremor-cli" ];

  meta = with lib; {
    description = "Early stage event processing system for unstructured data with rich support for structural pattern matching, filtering and transformation";
    homepage = "https://www.tremor.rs/";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ humancalico ];
  };
}
