{ lib, buildPythonPackage, fetchPypi, isPy27, pbr, sphinx, sphinx-testing, nose, glibcLocales }:

buildPythonPackage rec {
  pname = "sphinx-jinja";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hz13vc65zi4zmay40nz8wzxickv1q9zzl6x03qc7rvvapz0c91p";
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
    maintainers = with maintainers; [ nand0p ];
    license = licenses.mit;
  };
}
