{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pytestCheckHook
, pandas
, pytorch
}:

buildPythonPackage rec {
  pname = "slicer";
  version = "0.0.5";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8c0fe9845056207d7344d5850e93551f9be20656178d443332aa02da9c71ba44";
  };

  checkInputs = [ pytestCheckHook pandas pytorch ];

  meta = with lib; {
    description = "Wraps tensor-like objects and provides a uniform slicing interface via __getitem__";
    homepage = "https://github.com/interpretml/slicer";
    license = licenses.mit;
    maintainers = with maintainers; [ evax ];
    platforms = platforms.unix;
  };
}
