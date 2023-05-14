{ lib
, buildPythonPackage
, isPy27
, fetchPypi
}:

buildPythonPackage rec {
  pname = "stdlib-list";
  version = "0.8.0";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "17vdn4q0sdlndc2fr9svapxx6366hnrhkn0fswp1xmr0jxqh7rd1";
  };

  pythonImportsCheck = [
    "stdlib_list"
  ];

  # tests see mismatches to our standard library
  doCheck = false;

  meta = with lib; {
    description = "A list of Python Standard Libraries";
    homepage = "https://github.com/jackmaney/python-stdlib-list";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
