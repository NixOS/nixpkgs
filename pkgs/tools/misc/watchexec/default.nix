{ lib, stdenv, rustPlatform, fetchFromGitHub, Cocoa, AppKit, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "watchexec";
  version = "1.20.4";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "cli-v${version}";
    sha256 = "sha256-se3iqz+qjwf71wvHQhCWYryEdUc+kY0Q0ZTg4i1ayNI=";
  };

  cargoSha256 = "sha256-YM+Zm3wFp3Lsx5LmyjGwZywV/SZjriL6JMDO1l0tNf4=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ Cocoa AppKit ];

  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-framework AppKit";

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
