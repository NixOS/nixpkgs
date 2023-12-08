{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-enum34";
  version = "1.1.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0421lr89vv3fpg77kkj5nmzd7z3nmhw4vh8ibsjp6vfh86b7d73g";
  };

  pythonImportsCheck = [
    "enum-python2-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for enum34";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
