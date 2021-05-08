{ lib
, fetchFromGitHub
, buildPythonPackage
, nassl
, cryptography
, typing-extensions
, faker
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sslyze";
  version = "4.1.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nabla-c0d3";
    repo = pname;
    rev = version;
    hash = "sha256-oSTKNiECczlPAbv5Azc023PcquFbnlC5O+8tVgNcUW0=";
  };

  patchPhase = ''
    substituteInPlace setup.py \
      --replace "cryptography>=2.6,<3.5" "cryptography>=2.6,<4.0"
  '';

  checkInputs = [ pytestCheckHook ];

  # Most of the tests are online; hence, applicable tests are listed
  # explicitly here
  pytestFlagsArray = [
    "tests/test_main.py"
    "tests/test_scanner.py"
    "tests/cli_tests/test_console_output.py"
    "tests/cli_tests/test_json_output.py"
    "tests/cli_tests/test_server_string_parser.py"
    "tests/plugins_tests/test_scan_commands.py"
    "tests/plugins_tests/certificate_info/test_certificate_utils.py"
  ];

  disabledTests = [
    "test_error_client_certificate_needed"
  ];

  pythonImportsCheck = [ "sslyze" ];

  propagatedBuildInputs = [ nassl cryptography typing-extensions faker ];

  meta = with lib; {
    homepage = "https://github.com/nabla-c0d3/sslyze";
    description = "Fast and powerful SSL/TLS scanning library";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ veehaitch ];
  };
}
