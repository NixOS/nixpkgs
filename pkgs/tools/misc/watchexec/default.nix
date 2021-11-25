{ lib, stdenv, rustPlatform, fetchFromGitHub, CoreServices, Foundation, installShellFiles, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "watchexec";
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "cli-v${version}";
    sha256 = "13yqghdhakkwp607j84a1vbqgnqqn77a5mh27cr24352ik2vkrkq";
  };

  cargoSha256 = "0grzfzxw705zs5qb2h7k0yws45m20ihhh4mnpmk3wargbxpn6gsh";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices Foundation libiconv ];

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
