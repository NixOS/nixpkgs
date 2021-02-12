{ lib, stdenv, rustPlatform, fetchFromGitHub, CoreServices, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "watchexec";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0m4hipjgg64572lzqy9hz4iq9c4awc93c9rmnpap5iyi855x7idj";
  };

  cargoSha256 = "0gw32gnv57v5a86cck18p1m0zpmajxfr0n4pj4ad54kdy2brm1s0";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  postInstall = ''
    installManPage doc/watchexec.1
    installShellCompletion --zsh --name _watchexec completions/zsh
  '';

  meta = with lib; {
    description = "Executes commands in response to file modifications";
    homepage = "https://github.com/watchexec/watchexec";
    license = with licenses; [ asl20 ];
    maintainers = [ maintainers.michalrus ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
