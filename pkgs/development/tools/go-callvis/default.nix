{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go-callvis";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "ofabry";
    repo = "go-callvis";
    rev = "v${version}";
    hash = "sha256-PIzmnqlK+uFtzZW4H0xpP5c+X30hFvOjQydvreJn4xM=";
  };

  vendorHash = "sha256-AfbUxA5C5dH70+vqC+1RGaTt7S0FL9CBcxel0ifmHKs=";

  ldflags = [ "-s" "-w" ];

  # Build errors in github.com/goccy/go-graphviz/internal/ccall when format hardening is enabled:
  #   cc1: error: '-Wformat-security' ignored without '-Wformat' [-Werror=format-security]
  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "Visualize call graph of a Go program using Graphviz";
    mainProgram = "go-callvis";
    homepage = "https://github.com/ofabry/go-callvis";
    license = licenses.mit;
    maintainers = with maintainers; [ meain ];
  };
}
