{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "mdslides";
  version = "unstable-2022-12-15";

  src = fetchFromGitHub {
    owner  = "dadoomer";
    repo   = "markdown-slides";
    rev = "fd27dd09cf90f00093a393338e08953c8d65d68e";
    sha256 = "sha256-31ALsy1P/vfI+H6Onmg4TXLeKbVAQ1FlnFs4k6ZOgHQ=";
  };

  doCheck = false;

  meta = with lib; {
    longDescription = "Using markdown, write simple but beautiful presentations with math, animations and media, which can be visualized in a web browser or exported to PDF.";
    homepage    = "https://github.com/dadoomer/markdown-slides";
    license     = licenses.mit;
    maintainers = [ maintainers.qjoly ];
    mainProgram = "mdslides";
  };
}
