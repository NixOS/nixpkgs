{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, pytestCheckHook
, pandas
, pytorch
}:

buildPythonPackage rec {
  pname = "slicer";
  version = "0.0.4";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "21d53aac4e78c93fd83c0fd2f8f9d8a2195ac079dffdc0da81cd749da0f2f355";
  };

  checkInputs = [ pytestCheckHook pandas pytorch ];

  meta = with stdenv.lib; {
    description = "Wraps tensor-like objects and provides a uniform slicing interface via __getitem__";
    homepage = "https://github.com/interpretml/slicer";
    license = licenses.mit;
    maintainers = with maintainers; [ evax ];
    platforms = platforms.unix;
  };
}
