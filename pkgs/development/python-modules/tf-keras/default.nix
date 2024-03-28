{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
, wheel
, numpy
, tensorflow
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tf-keras";
  version = "2.15.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "tf_keras";
    inherit version;
    hash = "sha256-11WcK6QGZ2efyyEF0+S2i7wH7K+/EDdGLOezl0w8Z5g=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    numpy
    tensorflow
  ];

  pythonImportsCheck = [ "tf_keras" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Deep learning for humans";
    homepage = "https://pypi.org/project/tf-keras/";
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
