{ lib
, fetchFromGitHub
, buildPythonPackage
, pytestCheckHook
, pythonOlder
  # deps
, cryptography
, nassl
, pydantic
, tls-parser
  # check deps
, faker
, openssl_1_0_2
, openssl_1_1
}:

buildPythonPackage rec {
  pname = "sslyze";
  version = "5.0.2";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nabla-c0d3";
    repo = pname;
    rev = version;
    hash = "sha256-8xtnE5oFxH3wo2Smt65/xGDHxivexN6ggUpyUg42Cjk=";
  };

  patchPhase = ''
    substituteInPlace setup.py \
      --replace "cryptography>=2.6,<36.0.0" "cryptography>=2.6"
  '';

  checkInputs = [
    pytestCheckHook
    faker
  ];

  # Most of the tests are online; hence, applicable tests are listed
  # explicitly here
  pytestFlagsArray = [
    "tests/cli_tests/test_console_output.py"
    "tests/cli_tests/test_server_string_parser.py"
    "tests/json_tests/test_json_output.py"
    "tests/plugins_tests/certificate_info/test_certificate_algorithms.py"
    "tests/plugins_tests/certificate_info/test_certificate_utils.py"
    "tests/plugins_tests/certificate_info/test_symantec.py"
    "tests/plugins_tests/certificate_info/test_trust_store_repository.py"
    "tests/plugins_tests/openssl_cipher_suites/test_cipher_suites.py"
    "tests/plugins_tests/test_early_data_plugin.py"
    "tests/plugins_tests/test_http_headers_plugin.py"
    "tests/plugins_tests/test_robot_plugin.py"
    "tests/plugins_tests/test_scan_commands.py"
    "tests/plugins_tests/test_session_renegotiation_plugin.py"
    "tests/scanner_tests/test_jobs_worker_thread.py"
    "tests/scanner_tests/test_mass_scanner.py"
    "tests/scanner_tests/test_models.py"
    "tests/scanner_tests/test_scanner.py"
    "tests/server_connectivity_tests/test_client_authentication.py"
  ];

  disabledTests = [
    # TestEllipticCurvesPluginWithOnlineServer
    "test_supported_curves"
    # TestRobotPluginPlugin
    "test_robot_attack_good"
    # TestHttpHeadersPlugin
    "test_all_headers_disabled"
    "test_expect_ct_enabled"
    "test_hsts_enabled"
    # TestSessionRenegotiationPlugin
    "test_renegotiation_good"
    # TestCertificateAlgorithms
    "test_ecdsa_certificate"
    "test_invalid_certificate_bad_name"
    # TestEarlyDataPlugin
    "test_early_data_enabled"
    # TestTrustStoresRepository
    "test_update_default"
    # TestClientAuthentication
    "test_optional_client_authentication"
  ];

  # Some tests require OpenSSL
  preCheck = ''
    pushd $TMPDIR/$sourceRoot/tests/openssl_server/

    rm openssl-1-1-1-linux64
    ln -s ${openssl_1_1.bin}/bin/openssl openssl-1-1-1-linux64

    rm openssl-1-0-0e-linux64
    ln -s ${openssl_1_0_2.bin}/bin/openssl openssl-1-0-0e-linux64

    popd
  '';

  pythonImportsCheck = [ "sslyze" ];

  propagatedBuildInputs = [
    cryptography
    nassl
    pydantic
    tls-parser
  ];

  meta = with lib; {
    homepage = "https://github.com/nabla-c0d3/sslyze";
    description = "Fast and powerful SSL/TLS scanning library";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ veehaitch ];
  };
}
