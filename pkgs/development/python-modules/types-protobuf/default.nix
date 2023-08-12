{ lib
, buildPythonPackage
, fetchPypi
, types-futures
}:

buildPythonPackage rec {
  pname = "types-protobuf";
  version = "4.23.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EGawadTw4Jveu2TKTzXMa4rM9S+Ag2gEbM7JZ0SvA3U=";
  };

  propagatedBuildInputs = [
    types-futures
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "google-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for protobuf";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ andersk ];
  };
}
