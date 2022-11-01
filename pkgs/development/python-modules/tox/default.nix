{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, packaging
, pluggy
, py
, six
, virtualenv
, setuptools-scm
, tomli
, filelock
}:

buildPythonPackage rec {
  pname = "tox";
  version = "3.27.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0slF8CoD1FATdKPVQwh3OA3rabIYsd+bfx0vKhC++vk=";
  };

  buildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    packaging
    pluggy
    py
    six
    virtualenv
    filelock
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  doCheck = false;

  meta = with lib; {
    description = "Virtualenv-based automation of test activities";
    homepage = "https://tox.readthedocs.io/";
    license = licenses.mit;
  };
}
