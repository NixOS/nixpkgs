{ lib, buildPythonPackage, fetchPypi, pythonOlder
, attrs
, sortedcontainers
, async_generator
, idna
, outcome
, contextvars
, pytestCheckHook
, pyopenssl
, trustme
, sniffio
, stdenv
, jedi
, pylint
, astor
, yapf
}:

buildPythonPackage rec {
  pname = "trio";
  version = "0.16.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "df067dd0560c321af39d412cd81fc3a7d13f55af9150527daab980683e9fcf3c";
  };

  checkInputs = [ astor pytestCheckHook pyopenssl trustme jedi pylint yapf ];
  # It appears that the build sandbox doesn't include /etc/services, and these tests try to use it.
  disabledTests = [
    "getnameinfo"
    "SocketType_resolve"
    "getprotobyname"
    "waitpid"
    "static_tool_sees_all_symbols"
  ];

  propagatedBuildInputs = [
    attrs
    sortedcontainers
    async_generator
    idna
    outcome
    sniffio
  ] ++ lib.optionals (pythonOlder "3.7") [ contextvars ];

  # tests are failing on Darwin
  doCheck = !stdenv.isDarwin;

  meta = {
    description = "An async/await-native I/O library for humans and snake people";
    homepage = "https://github.com/python-trio/trio";
    license = with lib.licenses; [ mit asl20 ];
    maintainers = with lib.maintainers; [ catern ];
  };
}
