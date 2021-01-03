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
  ] ++ lib.optionals isPy27 [
    mock
  ];

  # The skipped tests are requiring a local web server
  checkPhase = ''
    HOME=$TMPDIR pytest \
      tests/test_{moduleman,filterintro,reqresp,api,clparser}.py
  '';

  meta = with lib; {
    description = "Web content fuzzer, to facilitate web applications assessments";
    homepage = "https://wfuzz.readthedocs.io";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
