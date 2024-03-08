{ lib
, buildPythonPackage
, fetchPypi
, colorama
, sphinx
, livereload
}:

buildPythonPackage rec {
  pname = "sphinx-autobuild";
  version = "2024.2.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-y50hIaF21i1FRxYkhyr8X613Va1mJzir5ADs9KeVQwM=";
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
