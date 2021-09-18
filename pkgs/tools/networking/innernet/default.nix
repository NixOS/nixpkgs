{ lib, stdenv, rustPlatform, fetchFromGitHub, llvmPackages, sqlite, installShellFiles, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "innernet";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "tonarino";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9oL91jacfUADaPvdTTvvXhpwzr9OnNnVLwy1okORss4=";
  };
  cargoSha256 = "sha256-jHWt7Jqv4B7u6Mvo3q69Omcn8kdnXGJSyzod1lDzvKE=";

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

  doInstallCheck = true;
  installCheckPhase = ''
    if [[ "$("$out/bin/${pname}"-server --version)" == "${pname}-server ${version}" ]]; then
      echo '${pname}-server smoke check passed'
    else
      echo '${pname}-server smoke check failed'
      return 1
    fi
    if [[ "$("$out/bin/${pname}" --version)" == "${pname} ${version}" ]]; then
      echo '${pname} smoke check passed'
    else
      echo '${pname} smoke check failed'
      return 1
    fi
  '';

  meta = with lib; {
    description = "A private network system that uses WireGuard under the hood";
    homepage = "https://github.com/tonarino/innernet";
    license = licenses.mit;
    maintainers = with maintainers; [ tomberek _0x4A6F ];
  };
}
