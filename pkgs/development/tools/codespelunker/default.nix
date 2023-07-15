{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "codespelunker";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "boyter";
    repo = "cs";
    rev = "v${version}";
    hash = "sha256-kWKDr8KKD3M5MyRuEMMZXvTqflDidkMsu2fN9N0s50w=";
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
