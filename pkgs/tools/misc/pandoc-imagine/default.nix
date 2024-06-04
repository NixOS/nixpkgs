{ fetchFromGitHub, buildPythonApplication, lib, pandocfilters, six }:

buildPythonApplication rec {
  pname = "pandoc-imagine";
  version = "0.1.6";

  src = fetchFromGitHub {
    repo = "imagine";
    owner = "hertogp";
    rev = version;
    sha256 = "1wpnckc7qyrf6ga5xhr6gv38k1anpy9nx888n7n3rh6nixzcz2dw";
  };

  propagatedBuildInputs = [ pandocfilters six ];

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    homepage = src.meta.homepage;
    description = ''
      A pandoc filter that will turn code blocks tagged with certain classes
      into images or ASCII art
    '';
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ synthetica ];
    mainProgram = "pandoc-imagine";
  };
}
