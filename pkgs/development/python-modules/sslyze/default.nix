{ lib
, fetchFromGitHub
, pytest
, buildPythonPackage
, nassl
, cryptography
, typing-extensions
, faker
}:

buildPythonPackage rec {
  pname = "sslyze";
  version = "3.0.8";

  src = fetchFromGitHub {
    owner = "nabla-c0d3";
    repo = pname;
    rev = version;
    sha256 = "06mwzxw6xaqin2gwzcqb9r7qhbyx3k7zcxygxywi2bpxyjv9lq32";
  };

  patchPhase = ''
    substituteInPlace setup.py \
      --replace "cryptography>=2.6,<=2.9" "cryptography>=2.6,<=3"
  '';

  checkInputs = [ pytest ];

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

  propagatedBuildInputs = [ nassl cryptography typing-extensions faker ];

  meta = with lib; {
    homepage = "https://github.com/nabla-c0d3/sslyze";
    description = "Fast and powerful SSL/TLS scanning library";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.agpl3;
    maintainers = with maintainers; [ veehaitch ];
  };
}
