{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "whisper";
  version = "1.1.10";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "graphite-project";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-CnCbRmI2jc67mTtfupoE1uHtobrAiWoUXbfX8YeEV6A=";
  };

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  disabledTests = [
    # whisper-resize.py: not found
    "test_resize_with_aggregate"
  ];

  pythonImportsCheck = [ "whisper" ];

  meta = with lib; {
    homepage = "https://github.com/graphite-project/whisper";
    description = "Fixed size round-robin style database";
    maintainers = with maintainers; [ offline basvandijk ];
    license = licenses.asl20;
  };
}
