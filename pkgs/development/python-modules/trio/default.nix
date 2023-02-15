{ lib, buildPythonPackage, fetchPypi, pythonOlder
, attrs
, sortedcontainers
, async_generator
, exceptiongroup
, idna
, outcome
, pytestCheckHook
, pyopenssl
, trustme
, sniffio
, stdenv
, jedi
, astor
, yapf
, coreutils
}:

buildPythonPackage rec {
  pname = "trio";
  version = "0.22.0";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zmjxxUAKR7E3xaTecsfJAb1OeiT73r/ptB3oxsBOqs8=";
  };

  propagatedBuildInputs = [
    attrs
    sortedcontainers
    async_generator
    idna
    outcome
    sniffio
  ] ++ lib.optionals (pythonOlder "3.11") [
    exceptiongroup
  ];

  # tests are failing on Darwin
  doCheck = !stdenv.isDarwin;

  nativeCheckInputs = [
    astor
    jedi
    pyopenssl
    pytestCheckHook
    trustme
    yapf
  ];

  preCheck = ''
    substituteInPlace trio/tests/test_subprocess.py \
      --replace "/bin/sleep" "${coreutils}/bin/sleep"
  '';

  # It appears that the build sandbox doesn't include /etc/services, and these tests try to use it.
  disabledTests = [
    "getnameinfo"
    "SocketType_resolve"
    "getprotobyname"
    "waitpid"
    "static_tool_sees_all_symbols"
    # tests pytest more than python
    "fallback_when_no_hook_claims_it"
  ];

  pytestFlagsArray = [
    "-W" "ignore::DeprecationWarning"
  ];

  meta = {
    description = "An async/await-native I/O library for humans and snake people";
    homepage = "https://github.com/python-trio/trio";
    license = with lib.licenses; [ mit asl20 ];
    maintainers = with lib.maintainers; [ catern ];
  };
}
