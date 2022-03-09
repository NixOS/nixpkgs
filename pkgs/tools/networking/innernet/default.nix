{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, llvmPackages
, sqlite
, installShellFiles
, Security
, libiconv
, innernet
, testVersion
}:

rustPlatform.buildRustPackage rec {
  pname = "innernet";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "tonarino";
    repo = "innernet";
    rev = "v${version}";
    sha256 = "sha256-dpoSjGtjGJTF/sQ8vbeAUCjnkYqz4zGnfO8br8gJbsQ=";
  };
  cargoSha256 = "sha256-EmAlm3W9r6pP1VIxeM2UP1ZG9TjopTarckMfLDonr1k=";

  nativeBuildInputs = with llvmPackages; [
    llvm
    clang
    installShellFiles
  ];
  buildInputs = [ sqlite ] ++ lib.optionals stdenv.isDarwin [ Security libiconv ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  postInstall = ''
    installManPage doc/innernet-server.8.gz
    installManPage doc/innernet.8.gz
    installShellCompletion doc/innernet.completions.{bash,fish,zsh}
    installShellCompletion doc/innernet-server.completions.{bash,fish,zsh}
  '';

  passthru.tests = {
    serverVersion = testVersion { package = innernet; command = "innernet-server --version"; };
    version = testVersion { package = innernet; command = "innernet --version"; };
  };

  meta = with lib; {
    description = "A private network system that uses WireGuard under the hood";
    homepage = "https://github.com/tonarino/innernet";
    license = licenses.mit;
    maintainers = with maintainers; [ tomberek _0x4A6F ];
  };
}
