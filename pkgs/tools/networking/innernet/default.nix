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
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "tonarino";
    repo = "innernet";
    rev = "v${version}";
    sha256 = "141zjfl125m5lrimam1dbpk40dqfq4vnaz42sbiq1v1avyg684fq";
  };
  cargoSha256 = "0559d0ayysvqs4k46fhgd4r8wa89abgx6rvhlh0gnlnga8vacpw5";

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
