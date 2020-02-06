{ lib, buildPythonPackage, fetchPypi, pythonOlder
, attrs
, sortedcontainers
, async_generator
, idna
, outcome
, contextvars
, pytest
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
  version = "0.13.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f1cf00054ad974c86d9b7afa187a65d79fd5995340abe01e8e4784d86f4acb30";
  };

  checkInputs = [ astor pytest pyopenssl trustme jedi pylint yapf ];
  # It appears that the build sandbox doesn't include /etc/services, and these tests try to use it.
  checkPhase = ''
    HOME=$TMPDIR py.test -k 'not getnameinfo \
                             and not SocketType_resolve \
                             and not getprotobyname \
                             and not waitpid \
                             and not static_tool_sees_all_symbols'
  '';

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
    homepage = https://github.com/python-trio/trio;
    license = with lib.licenses; [ mit asl20 ];
    maintainers = with lib.maintainers; [ catern ];
  };
}
