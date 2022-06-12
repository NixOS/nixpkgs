{ stdenv
, lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "boofuzz";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "jtpereyda";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mbxImm5RfYWq1JCCSvvG58Sxv2ad4BOh+RLvtNjQCKE=";
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

  checkInputs = with python3.pkgs; [
    mock
    netifaces
    pytest-bdd
    pytestCheckHook
  ];

  disabledTests = [
    # Tests require socket access
    "test_raw_l2"
    "test_raw_l3"
  ];

  pythonImportsCheck = [
    "boofuzz"
  ];

  meta = with lib; {
    description = "Network protocol fuzzing tool";
    homepage = "https://github.com/jtpereyda/boofuzz";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ fab ];
    # FAILED unit_tests/test_monitors.py::TestProcessMonitor::test_set_options_persistent
    broken = (stdenv.isDarwin && stdenv.isx86_64);
  };
}
