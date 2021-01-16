{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, sphinx
, livereload
}:

buildPythonPackage rec {
  pname = "sphinx-autobuild";
  version = "2020.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vbaf4vrxahylyp8zrlw5dx1d2faajp926c3pl5i1wlkp1yll62b";
  };

  propagatedBuildInputs = [ sphinx livereload ];

  # No tests included.
  doCheck = false;
  pythonImportsCheck = [ "sphinx_autobuild" ];

  meta = with lib; {
    description = "Rebuild Sphinx documentation on changes, with live-reload in the browser";
    homepage = "https://github.com/executablebooks/sphinx-autobuild";
    license = with licenses; [ mit ];
    maintainer = with maintainers; [holgerpeters];
  };
}
