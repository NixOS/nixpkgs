{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "ea";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "dduan";
    repo = "ea";
    rev = version;
    sha256 = "VXSSe5d7VO3LfjumzN9a7rrKRedOtOzTdLVQWgV1ED8=";
  };

  cargoSha256 = "sha256-YP7OJaIWTXJHe3qF+a3zCFnCHnELX0rAWqnJPaC1T7I=";

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
  ];

  postInstall = ''
    installManPage docs/ea.1
  '';

  meta = with lib; {
    description = "Makes file paths from CLI output actionable";
    homepage = "https://github.com/dduan/ea";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ deejayem ];
  };
}
