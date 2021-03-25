{ lib
, fetchFromGitHub
, buildPythonPackage
, nassl
, cryptography
, typing-extensions
, faker
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sslyze";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "nabla-c0d3";
    repo = pname;
    rev = version;
    sha256 = "02p0lgpkfq88dys0dqw0z8bpg9g8pds2lvs9awd9f2w5cb1pwr83";
  };

  patchPhase = ''
    substituteInPlace setup.py \
      --replace "cryptography>=2.6,<3.3" "cryptography>=2.6,<4.0"
  '';

  checkInputs = [ pytestCheckHook ];

  checkPhase = ''
    # Most of the tests are online; hence, applicable tests are listed
    # explicitly here
    pytest \
      tests/test_main.py \
      tests/test_scanner.py \
      tests/cli_tests/test_console_output.py \
      tests/cli_tests/test_json_output.py \
      tests/cli_tests/test_server_string_parser.py \
      tests/plugins_tests/test_scan_commands.py \
      tests/plugins_tests/certificate_info/test_certificate_utils.py \
      -k "not (TestScanner and test_client_certificate_missing)"
  '';
  pythonImportsCheck = [ "sslyze" ];

  propagatedBuildInputs = [ nassl cryptography typing-extensions faker ];

  meta = with lib; {
    homepage = "https://github.com/nabla-c0d3/sslyze";
    description = "Fast and powerful SSL/TLS scanning library";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.agpl3;
    maintainers = with maintainers; [ veehaitch ];
  };
}
