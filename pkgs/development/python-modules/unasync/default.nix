{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "unasync";
  version = "0.5.0";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "python-trio";
    repo = "unasync";
    rev = "v${version}";
    sha256 = "0h86i09v4909a8nk5lp36jlwz6rsln6vyg3d0i13ykxa6lrx1c2l";
  };

  propagatedBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # mess with $PYTHONPATH
    "test_build_py_modules"
    "test_build_py_packages"
    "test_project_structure_after_build_py_packages"
    "test_project_structure_after_customized_build_py_packages"
  ];

  pythonImportsCheck = [ "unasync" ];

  meta = with lib; {
    description = "Project that can transform your asynchronous code into synchronous code";
    homepage = "https://github.com/python-trio/unasync";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ dotlambda ];
  };
}
