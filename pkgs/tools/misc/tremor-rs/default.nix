{ lib, rustPlatform, pkg-config, cmake, llvmPackages, openssl, fetchFromGitHub
, installShellFiles, stdenv, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "tremor";
  version = "0.11.6";

  src = fetchFromGitHub {
    owner = "tremor-rs";
    repo = "tremor-runtime";
    rev = "v${version}";
    sha256 = "1ldqa4q7q9afrbjh7adinav21zsh26pqqvrd6q9542r90mxnygmx";
  };

  cargoSha256 = "0ivxd5mhvcpzv9wf859vwyiq1s0bbd9vdk6fy6m81bn5ykihx7ar";

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
    broken = stdenv.isDarwin;
    description = "Early stage event processing system for unstructured data with rich support for structural pattern matching, filtering and transformation";
    homepage = "https://www.tremor.rs/";
    license = licenses.asl20;
    platforms = platforms.x86_64;
    maintainers = with maintainers; [ humancalico ];
  };
}
