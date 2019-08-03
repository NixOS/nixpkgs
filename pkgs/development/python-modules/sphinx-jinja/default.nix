{ lib, buildPythonPackage, fetchPypi, pbr, sphinx, sphinx-testing, nose, glibcLocales }:

buildPythonPackage rec {
  pname = "sphinx-jinja";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02pgp9pbn0zrs0lggrc74mv6cvlnlq8wib84ga6yjvq30gda9v8q";
  };

  buildInputs = [ pbr ];
  propagatedBuildInputs = [ sphinx ];

  checkInputs = [ sphinx-testing nose glibcLocales ];

  checkPhase = ''
    # Zip (epub) does not support files with epoch timestamp
    LC_ALL="en_US.UTF-8" nosetests -e test_build_epub
  '';

  meta = with lib; {
    description = "Sphinx extension to include jinja templates in documentation";
    maintainers = with maintainers; [ nand0p ];
    license = licenses.mit;
  };
}
