{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "codespelunker";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "boyter";
    repo = "cs";
    rev = "v${version}";
    hash = "sha256-9Od2SOUYf4ij+UWOX/1kWS+qUZRje1wjzSAzBc5qk8s=";
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
