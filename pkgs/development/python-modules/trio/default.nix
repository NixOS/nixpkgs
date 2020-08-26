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
  version = "0.15.1";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3010864ab8d8b2ae44d3bc97b0e8924d8f5170bf32f07c7638a930a129687f33";
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
    homepage = "https://github.com/python-trio/trio";
    license = with lib.licenses; [ mit asl20 ];
    maintainers = with lib.maintainers; [ catern ];
  };
}
