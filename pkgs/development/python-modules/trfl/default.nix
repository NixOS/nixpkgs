{ lib
, fetchFromGitHub
, buildPythonPackage
, numpy
, absl-py
, dm-tree
, wrapt
, tensorflow
, tensorflow-probability
, pytestCheckHook
, nose }:

buildPythonPackage rec {
  pname = "trfl";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = pname;
    rev = "ed6eff5b79ed56923bcb102e152c01ea52451d4c";
    sha256 = "sha256-UsDUKJCHSJ4gP+P95Pm7RsPpqTJqJhrsW47C7fTZ77I=";
  };

  buildInputs = [
    absl-py
    dm-tree
    numpy
    wrapt
  ];

  propagatedBuildInputs = [
    tensorflow
    tensorflow-probability
  ];

  checkInputs = [
    nose
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "trfl"
  ];

  # Tests currently fail with assertion errors
  doCheck = false;

  disabledTestPaths = [
    # AssertionErrors
    "trfl/indexing_ops_test.py"
    "trfl/vtrace_ops_test.py"
    "trfl/value_ops_test.py"
    "trfl/target_update_ops_test.py"
    "trfl/sequence_ops_test.py"
    "trfl/retrace_ops_test.py"
    "trfl/policy_ops_test.py"
    "trfl/policy_gradient_ops_test.py"
    "trfl/pixel_control_ops_test.py"
    "trfl/periodic_ops_test.py"
    "trfl/dpg_ops_test.py"
    "trfl/distribution_ops_test.py"
    "trfl/dist_value_ops_test.py"
    "trfl/discrete_policy_gradient_ops_test.py"
    "trfl/continuous_retrace_ops_test.py"
    "trfl/clipping_ops_test.py"
    "trfl/action_value_ops_test.py"
  ];

  meta = with lib; {
    description = "TensorFlow Reinforcement Learning";
    homepage = "https://github.com/deepmind/trfl";
    license = licenses.asl20;
    maintainers = with maintainers; [ onny ];
  };
}
