{ lib
, stdenv
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "boofuzz";
  version = "0.4.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jtpereyda";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-mbxImm5RfYWq1JCCSvvG58Sxv2ad4BOh+RLvtNjQCKE=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    attrs
    click
    colorama
    flask
    funcy
    future
    psutil
    pyserial
    pydot
    six
    tornado
  ];

  nativeCheckInputs = with python3.pkgs; [
    mock
    netifaces
    pytest-bdd
    pytestCheckHook
  ];

  disabledTests = [
    "TestNetworkMonitor"
    "TestNoResponseFailure"
    "TestProcessMonitor"
    "TestSocketConnection"
    # SyntaxError: invalid syntax, https://github.com/jtpereyda/boofuzz/issues/663
    "test_msg_60_bytes"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_time_repeater"
  ];

  pythonImportsCheck = [
    "boofuzz"
  ];

  meta = with lib; {
    description = "Network protocol fuzzing tool";
    homepage = "https://github.com/jtpereyda/boofuzz";
    changelog = "https://github.com/jtpereyda/boofuzz/blob/v${version}/CHANGELOG.rst";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
