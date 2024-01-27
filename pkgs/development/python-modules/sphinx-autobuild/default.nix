{ lib
, buildPythonPackage
, fetchPypi
, colorama
, sphinx
, livereload
}:

buildPythonPackage rec {
  pname = "sphinx-autobuild";
  version = "2021.3.14";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "de1ca3b66e271d2b5b5140c35034c89e47f263f2cd5db302c9217065f7443f05";
  };

  propagatedBuildInputs = [
    colorama
    sphinx
    livereload
  ];

  # No tests included.
  doCheck = false;

  pythonImportsCheck = [ "sphinx_autobuild" ];

  meta = with lib; {
    description = "Rebuild Sphinx documentation on changes, with live-reload in the browser";
    homepage = "https://github.com/executablebooks/sphinx-autobuild";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [holgerpeters];
  };
}
