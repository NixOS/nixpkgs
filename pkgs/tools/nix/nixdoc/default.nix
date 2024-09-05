{ lib, stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "nixdoc";
  version = "3.0.8";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixdoc";
    rev = "v${version}";
    sha256 = "sha256-0tMGTKcuvyDE5281nGCvZKYJKIEAU01G6vV8Fnt/1ZQ=";
  };

  cargoHash = "sha256-5KV2VDsPmSgrdZIqCuQ5gjgCVs/Ki6uG6GTwjmtKLlQ=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.Security ];

  meta = with lib; {
    description = "Generate documentation for Nix functions";
    mainProgram = "nixdoc";
    homepage    = "https://github.com/nix-community/nixdoc";
    license     = [ licenses.gpl3 ];
    maintainers = with maintainers; [
      infinisil
      hsjobeki
    ];
    platforms   = platforms.unix;
  };
}
