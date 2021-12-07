{ buildPythonPackage, fetchPypi, lib, types-futures }:

buildPythonPackage rec {
  pname = "types-protobuf";
  version = "3.18.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ca21dedfe7759acbeb0cd8f5c72a74ff3c409ae0c07bc1d94eff5123ac0fa23c";
  };

  propagatedBuildInputs = [ types-futures ];

  meta = with lib; {
    description = "Typing stubs for protobuf";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ andersk ];
  };
}
