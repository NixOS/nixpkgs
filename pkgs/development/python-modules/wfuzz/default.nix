{ buildPythonPackage
, chardet
, colorama
, configparser
, fetchFromGitHub
, future
, isPy27
, lib
, mock
, netaddr
, pkgs
, pycurl
, pyparsing
, pytest
, pytestCheckHook
, setuptools
, six
, stdenv
}:

buildPythonPackage rec {
  pname = "wfuzz";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "xmendez";
    repo = pname;
    rev = "v${version}";
    sha256 = "1izasczm2zwknwzxbfzqhlf4zp02jvb54ha1hfk4rlwiz0rr1kj4";
  };

  propagatedBuildInputs = [
    chardet
    pycurl
    six
    setuptools
    pyparsing
  ] ++ lib.optionals isPy27 [
    mock
    future
  ] ++ lib.optionals stdenv.hostPlatform.isWindows [
    colorama
  ];

  checkInputs = [
    netaddr
    pytest
    pytestCheckHook
  ] ++ lib.optionals isPy27 [
    mock
  ];

  preCheck = "export HOME=$(mktemp -d)";
  # The skipped tests are requiring a local web server
  pytestFlagsArray = [ "tests/test_{moduleman,filterintro,reqresp,api,clparser}.py" ];
  pythonImportsCheck = [ "wfuzz" ];

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
