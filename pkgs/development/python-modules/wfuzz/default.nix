{ lib
, stdenv
, buildPythonPackage
, chardet
, colorama
, fetchFromGitHub
, netaddr
, pycurl
, pyparsing
, pytest
, pytestCheckHook
, pythonOlder
, setuptools
, six
}:

buildPythonPackage rec {
  pname = "wfuzz";
  version = "3.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "xmendez";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-RM6QM/iR00ymg0FBUtaWAtxPHIX4u9U/t5N/UT/T6sc=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pyparsing>=2.4*" "pyparsing>=2.4"
  '';

  propagatedBuildInputs = [
    chardet
    pycurl
    six
    setuptools
    pyparsing
  ] ++ lib.optionals stdenv.hostPlatform.isWindows [
    colorama
  ];

  nativeCheckInputs = [
    netaddr
    pytest
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTestPaths = [
    # The tests are requiring a local web server
    "tests/test_acceptance.py"
    "tests/acceptance/test_saved_filter.py"
  ];

  pythonImportsCheck = [
    "wfuzz"
  ];

  meta = with lib; {
    description = "Web content fuzzer to facilitate web applications assessments";
    longDescription = ''
      Wfuzz provides a framework to automate web applications security assessments
      and could help you to secure your web applications by finding and exploiting
      web application vulnerabilities.
    '';
    homepage = "https://wfuzz.readthedocs.io";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ pamplemousse ];
  };
}
