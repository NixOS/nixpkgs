{ fetchFromGitHub, buildPythonApplication, lib, pandocfilters, six }:

buildPythonApplication rec {
  pname = "pandoc-imagine";
  version = "unstable-2018-11-19";

  src = fetchFromGitHub {
    repo = "imagine";
    owner = "hertogp";
    rev = "cc9be85155666c2d12d47a71690ba618cea1fac2";
    sha256 = "0iksh9081g488yfjzd24bz4lm1nrrjamph1vynx3imrcfgyq7nsb";
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
  };
}
