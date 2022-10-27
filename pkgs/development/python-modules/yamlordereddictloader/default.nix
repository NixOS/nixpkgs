{ lib
, buildPythonPackage
, fetchPypi
, pyyaml
}:

buildPythonPackage rec {
  pname = "yamlordereddictloader";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03h8wa6pzqjiw25s3jv9gydn77gs444mf31lrgvpgy53kswz0c3z";
  };

  propagatedBuildInputs = [ pyyaml ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "yamlordereddictloader" ];

  meta = with lib; {
    description = "YAML loader and dump for PyYAML allowing to keep keys order";
    homepage = "https://github.com/fmenabe/python-yamlordereddictloader";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
