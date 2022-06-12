{ lib, stdenv, rustPlatform, fetchFromGitHub, CoreServices, Foundation, installShellFiles, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "watchexec";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "cli-v${version}";
    sha256 = "sha256-Zqu6Qor7kHSeOFyHjcrl6RhB8gL9pljHt7hEd6/0Kss=";
  };

  cargoSha256 = "sha256-XwgoYaqgDkNggzi2TL/JPfh8LSFSzSWOVMbkmhXX73I=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices Foundation libiconv ];

  checkFlags = [ "--skip=help" "--skip=help_short" ];

  postInstall = ''
    installManPage doc/watchexec.1
    installShellCompletion --zsh --name _watchexec completions/zsh
  '';

  meta = with lib; {
    description = "Executes commands in response to file modifications";
    homepage = "https://watchexec.github.io/";
    license = with licenses; [ asl20 ];
    maintainers = [ maintainers.michalrus ];
  };
}
