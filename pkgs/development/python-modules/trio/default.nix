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
}:

buildPythonPackage rec {
  pname = "trio";
  version = "0.11.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3796774aedbf5be581c68f98c79b565654876de6e9a01c6a95e3ec6cd4e4b4c3";
  };

  checkInputs = [ pytest pyopenssl trustme jedi pylint ];
  # It appears that the build sandbox doesn't include /etc/services, and these tests try to use it.
  checkPhase = ''
    HOME="$(mktemp -d)" py.test -k 'not test_getnameinfo and not test_SocketType_resolve and not test_getprotobyname and not test_waitpid'
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
