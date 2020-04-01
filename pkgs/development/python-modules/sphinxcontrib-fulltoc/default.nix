{ lib, buildPythonPackage, fetchPypi, pythonOlder, sphinx, pbr }:

buildPythonPackage rec {
  pname = "sphinxcontrib-fulltoc";
  version = "1.2.0";

  # pkgutil namespaces are broken in nixpkgs (because they can't scan multiple
  # directories). But python2 is EOL, so not supporting it, should be ok.
  disabled = pythonOlder "3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nbwflv9szyh37yr075xhck8b4gg2c7g3sa38mfi7wv7qhpxcif8";
  };

  nativeBuildInputs = [ pbr ];
  propagatedBuildInputs = [ sphinx ];

  # There are no unit tests
  doCheck = false;
  # Ensure package importing works
  pythonImportsCheck = [ "sphinxcontrib.fulltoc" ];

  meta = with lib; {
    description = "Include a full table of contents in your Sphinx HTML sidebar";
    homepage = "https://sphinxcontrib-fulltoc.readthedocs.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ jluttine ];
  };
}
