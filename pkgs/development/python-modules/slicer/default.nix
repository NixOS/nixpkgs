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
  version = "0.0.7";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f5d5f7b45f98d155b9c0ba6554fa9770c6b26d5793a3e77a1030fb56910ebeec";
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
