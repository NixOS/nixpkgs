{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "riffdiff";
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    rev = version;
    hash = "sha256-IdYQ8vD3ZIzqdNY4JtR8f2huV/DWOhV8FUn7tuRe7IQ=";
  };

  cargoHash = "sha256-1on4CTstEvjNLtk1RG6dcNl0XhaPYAy+U0DYn/aVzEg=";

  meta = with lib; {
    description = "Diff filter highlighting which line parts have changed";
    homepage = "https://github.com/walles/riff";
    license = licenses.mit;
    maintainers = with maintainers; [ johnpyp ];
    mainProgram = "riff";
  };
}
