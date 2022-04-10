{ lib
, buildPythonPackage
, fetchPypi
, matplotlib
, pytestCheckHook
, numpy
, pandas
, pythonOlder
, scipy
}:

buildPythonPackage rec {
  pname = "seaborn";
  version = "0.11.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf45e9286d40826864be0e3c066f98536982baf701a7caa386511792d61ff4f6";
  };

  propagatedBuildInputs = [
    matplotlib
    numpy
    pandas
    scipy
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Tests may occasionally fail with small offsets
    "test_ndarray_input"
    "test_df_input"
    "test_axis0_input"
    "test_linkage_scipy"
  ];

  pythonImportsCheck= [
    "seaborn"
  ];

  meta = {
    description = "Statisitical data visualization";
    homepage = "https://seaborn.pydata.org/";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}
