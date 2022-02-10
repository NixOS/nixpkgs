{ lib, buildPythonPackage, fetchPypi, isPy27, pbr, sphinx, sphinx-testing, nose, glibcLocales }:

buildPythonPackage rec {
  pname = "sphinx-jinja";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e6614d986c0289cb85b016c25eb8cb9781ceb841e70bee639c5123f39ad90b38";
  };

  buildInputs = [ pbr ];
  propagatedBuildInputs = [ sphinx ];

  checkInputs = [ sphinx-testing nose glibcLocales ];

  checkPhase = lib.optionalString (!isPy27) ''
    # prevent python from loading locally and breaking namespace
    mv sphinxcontrib .sphinxcontrib
  '' + ''
    # Zip (epub) does not support files with epoch timestamp
    LC_ALL="en_US.UTF-8" nosetests -e test_build_epub
  '';

  meta = with lib; {
    description = "Sphinx extension to include jinja templates in documentation";
    maintainers = with maintainers; [ ];
    license = licenses.mit;
  };
}
