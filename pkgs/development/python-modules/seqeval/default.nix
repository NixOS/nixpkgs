{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, scikit-learn
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "seqeval";
  version = "1.2.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "chakki-works";
    repo = "seqeval";
    rev = "v${version}";
    sha256 = "0qv05gn54kc4wpmwnflmfqw4gwwb8lxqhkiihl0pvl7s2i7qzx2j";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "use_scm_version=True," "version='${version}'," \
      --replace "setup_requires=['setuptools_scm']," "setup_requires=[],"
  '';

  propagatedBuildInputs = [
    numpy
    scikit-learn
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # tests call perl script and get stuck in there
    "test_statistical_tests"
    "test_by_ground_truth"
  ];

  meta = with lib; {
    description = "A Python framework for sequence labeling evaluation";
    homepage = "https://github.com/chakki-works/seqeval";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
