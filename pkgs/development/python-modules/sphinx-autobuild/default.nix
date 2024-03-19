{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, colorama
, sphinx
, livereload
}:

buildPythonPackage rec {
  pname = "sphinx-autobuild";
  version = "2024.2.4";
  pyproject = true;

  src = fetchPypi {
    pname = "sphinx_autobuild";
    inherit version;
    hash = "sha256-y50hIaF21i1FRxYkhyr8X613Va1mJzir5ADs9KeVQwM=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [
    colorama
    sphinx
    livereload
  ];

  # No tests included.
  doCheck = false;

  pythonImportsCheck = [ "sphinx_autobuild" ];

  meta = with lib; {
    description = "Rebuild Sphinx documentation on changes, with live-reload in the browser";
    mainProgram = "sphinx-autobuild";
    homepage = "https://github.com/sphinx-doc/sphinx-autobuild";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [holgerpeters];
  };
}
