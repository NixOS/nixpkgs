{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, sphinx
, markdown
, CommonMark
, recommonmark
, pydash
, pyyaml
, unify
, yapf
, python
}:

buildPythonPackage rec {
  pname = "sphinx-markdown-parser";
  version = "0.2.4";

  # PyPi release does not include requirements.txt
  src = fetchFromGitHub {
    owner = "clayrisser";
    repo = "sphinx-markdown-parser";
    # Upstream maintainer currently does not tag releases
    # https://github.com/clayrisser/sphinx-markdown-parser/issues/35
    rev = "2fd54373770882d1fb544dc6524c581c82eedc9e";
    sha256 = "0i0hhapmdmh83yx61lxi2h4bsmhnzddamz95844g2ghm132kw5mv";
  };

  propagatedBuildInputs = [ sphinx markdown CommonMark pydash pyyaml unify yapf recommonmark ];

  # Avoids running broken tests in test_markdown.py
  checkPhase = ''
    ${python.interpreter} -m unittest -v tests/test_basic.py tests/test_sphinx.py
  '';

  pythonImportsCheck = [ "sphinx_markdown_parser" ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Write markdown inside of docutils & sphinx projects";
    homepage = "https://github.com/clayrisser/sphinx-markdown-parser";
    license = licenses.mit;
    maintainers = with maintainers; [ FlorianFranzen ];
  };
}
