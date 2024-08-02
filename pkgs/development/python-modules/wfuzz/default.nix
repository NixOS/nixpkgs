{
  lib,
  stdenv,
  buildPythonPackage,
  chardet,
  colorama,
  fetchFromGitHub,
  netaddr,
  pycurl,
  pyparsing,
  pytest,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  six,
  fetchpatch2,
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

  patches = [
    # replace use of imp module for Python 3.12
    # https://github.com/xmendez/wfuzz/pull/365
    (fetchpatch2 {
      url = "https://github.com/xmendez/wfuzz/commit/f4c028b9ada4c36dabf3bc752f69f6ddc110920f.patch?full_index=1";
      hash = "sha256-t7pUMcdFmwAsGUNBRdZr+Jje/yR0yzeGIgeYNEq4hFE=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pyparsing>=2.4*" "pyparsing>=2.4"

    # fix distutils use for Python 3.12
    substituteInPlace src/wfuzz/plugin_api/base.py \
      --replace-fail "from distutils import util" "from setuptools._distutils import util"
  '';

  propagatedBuildInputs = [
    chardet
    pycurl
    six
    setuptools
    pyparsing
  ] ++ lib.optionals stdenv.hostPlatform.isWindows [ colorama ];

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
    # depends on imp module removed from Python 3.12
    "tests/test_moduleman.py"
  ];

  pythonImportsCheck = [ "wfuzz" ];

  postInstall = ''
    mkdir -p $out/share/wordlists/wfuzz
    cp -R -T "wordlist" "$out/share/wordlists/wfuzz"
  '';

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
