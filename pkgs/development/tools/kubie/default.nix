{ lib, stdenv, rustPlatform, fetchFromGitHub, installShellFiles, Security }:

rustPlatform.buildRustPackage rec {
  pname = "kubie";
  version = "0.19.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "sbstp";
    repo = "kubie";
    sha256 = "sha256-tZ4qa48I/J62bqc9eoSSpTrJjU+LpweF/kI1TMiFrEY=";
  };

  cargoSha256 = "sha256-WpX1wkMPtUwT6KOi0Bij1tzGlDhti828wBSfzpXuZaY=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  postInstall = ''
    installShellCompletion completion/kubie.bash
  '';

  meta = with lib; {
    description = "Shell independent context and namespace switcher for kubectl";
    homepage = "https://github.com/sbstp/kubie";
    license = with licenses; [ zlib ];
    maintainers = with maintainers; [ illiusdope ];
  };
}
