{ lib
, blockdiag
, buildPythonPackage
, fetchFromGitHub
, nose
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "seqdiag";
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "blockdiag";
    repo = pname;
    rev = version;
    hash = "sha256-Dh9JMx50Nexi0q39rYr9MpkKmQRAfT7lzsNOXoTuphg=";
  };

  propagatedBuildInputs = [
    blockdiag
    setuptools
  ];

  nativeCheckInputs = [
    nose
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "src/seqdiag/tests/"
  ];

  disabledTests = [
    # UnicodeEncodeError: 'latin-1' codec can't encode...
    "test_setup_inline_svg_is_true_with_multibytes"
  ];

  pythonImportsCheck = [
    "seqdiag"
  ];

  meta = with lib; {
    description = "Generate sequence-diagram image from spec-text file (similar to Graphviz)";
    homepage = "http://blockdiag.com/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
