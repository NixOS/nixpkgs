{ lib, rustPlatform, pkg-config, cmake, llvmPackages, openssl, fetchFromGitHub
, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "tremor";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "tremor-rs";
    repo = "tremor-runtime";
    rev = "v${version}";
    sha256 = "1z1khxfdj2j0xf7dp0x2cd9kl6r4qicp7kc4p4sdky2yib66512y";
  };

  cargoSha256 = "sha256-rN/d6BL2d0D0ichQR6v0543Bh/Y2ktz8ExMH50M8B8c=";

  nativeBuildInputs = [ cmake pkg-config installShellFiles ];

  buildInputs = [ openssl ];

  postInstall = ''
    installShellCompletion --cmd tremor \
      --bash <($out/bin/tremor completions bash) \
      --fish <($out/bin/tremor completions fish) \
      --zsh <($out/bin/tremor completions zsh)
  '';

  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  # OPENSSL_NO_VENDOR - If set, always find OpenSSL in the system, even if the vendored feature is enabled.
  OPENSSL_NO_VENDOR = 1;

  cargoBuildFlags = [ "--all" ];

  meta = with lib; {
    description = "Early stage event processing system for unstructured data with rich support for structural pattern matching, filtering and transformation";
    homepage = "https://www.tremor.rs/";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ humancalico ];
  };
}
