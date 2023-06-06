{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "codespelunker";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "boyter";
    repo = "cs";
    rev = "v${version}";
    hash = "sha256-NN/78paePdvYHQ4J2aQu56PvEciOXY8DxHd4ajfVCFU=";
  };

  vendorHash = null;

  subPackages = [ "." ];

  meta = with lib; {
    description = "A command code search tool";
    homepage = "https://github.com/boyter/cs";
    license = with licenses; [ mit unlicense ];
    maintainers = with maintainers; [ viraptor ];
    mainProgram = "cs";
  };
}
