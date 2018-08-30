{ lib, buildPythonPackage, fetchPypi
, pbr, sphinx, blockdiag
, sphinx-testing, nose, glibcLocales }:

buildPythonPackage rec {
  pname = "sphinx-jinja";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18eda4da03036fe98d7a04adc811a6966e66762587e5f728d0f903bb6ebaef0a";
  };

  buildInputs = [ pbr ];

  propagatedBuildInputs = [ sphinx blockdiag ];

  checkInputs = [ sphinx-testing nose glibcLocales ];

  checkPhase = ''
    LC_ALL="en_US.UTF-8" nosetests -e test_build_epub
  '';

  meta = with lib; {
    description = "Includes jinja templates in a documentation";
    maintainers = with maintainers; [ nand0p ];
    license = licenses.mit;
  };
}
