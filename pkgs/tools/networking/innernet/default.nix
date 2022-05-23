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
, testers
}:

rustPlatform.buildRustPackage rec {
  pname = "innernet";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "tonarino";
    repo = "innernet";
    rev = "v${version}";
    sha256 = "sha256-CcZ4241EU+ktPbFsuR/sF4yP6xAOFg+oW8thtAQZr/4=";
  };
  cargoSha256 = "sha256-7APUSDxw6X4KJnFvm6xhiHL1D4NTNS2pC/4UVGyjJYY=";

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
  '' + (lib.optionalString stdenv.isLinux ''
    find . -regex '.*\.\(target\|service\)' | xargs install -Dt $out/lib/systemd/system
    find $out/lib/systemd/system -type f | xargs sed -i "s|/usr/bin/innernet|$out/bin/innernet|"
  '');

  passthru.tests = {
    serverVersion = testers.testVersion { package = innernet; command = "innernet-server --version"; };
    version = testers.testVersion { package = innernet; command = "innernet --version"; };
  };

  meta = with lib; {
    description = "A private network system that uses WireGuard under the hood";
    homepage = "https://github.com/tonarino/innernet";
    license = licenses.mit;
    maintainers = with maintainers; [ tomberek _0x4A6F ];
  };
}
