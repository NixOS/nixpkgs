{ lib, stdenv, rustPlatform, fetchFromGitHub, CoreServices, installShellFiles, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "watchexec";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1b0ds04q4g8xcgwkziwb5hsi7v73w9y0prvhxz880zzh930652n2";
  };

  cargoSha256 = "0jpfgyz5l4fdb5cnqmadzjzrvc6dwgray4b0mx80pghpjw8a8qfb";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices libiconv ];

  postInstall = ''
    installManPage doc/watchexec.1
    installShellCompletion --zsh --name _watchexec completions/zsh
  '';

  meta = with lib; {
    description = "Executes commands in response to file modifications";
    homepage = "https://github.com/watchexec/watchexec";
    license = with licenses; [ asl20 ];
    maintainers = [ maintainers.michalrus ];
  };
}
