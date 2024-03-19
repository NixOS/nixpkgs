{ lib
, buildPythonPackage
, dask
, fetchpatch
, fetchPypi
, numba
, numpy
, pytestCheckHook
, pythonOlder
, scipy
}:

buildPythonPackage rec {
  pname = "sparse";
  version = "0.14.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-X1gno39s1vZzClQfmUyVxgo64jKeAfS6Ic7VM5rqAJg=";
  };

  patches = [
    # https://github.com/pydata/sparse/issues/594
    (fetchpatch {
      name = "fix-test.patch";
      url = "https://github.com/pydata/sparse/commit/a55651d630efaea6fd2758d083c6d02333b0eebe.patch";
      hash = "sha256-Vrx7MDlKtA8fOuFZenEkvgA70Hzm+p/4SPZuCvwtLuo=";
    })
  ];

  propagatedBuildInputs = [
    numba
    numpy
    scipy
  ];

  nativeCheckInputs = [
    dask
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sparse"
  ];

  meta = with lib; {
    description = "Sparse n-dimensional arrays computations";
    homepage = "https://sparse.pydata.org/";
    changelog = "https://sparse.pydata.org/en/stable/changelog.html";
    downloadPage = "https://github.com/pydata/sparse/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
