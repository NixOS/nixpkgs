{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "whisper";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "graphite-project";
    repo = pname;
    rev = version;
    sha256 = "11f7sarj62zgpw3ak4a2q55lj7ap4039l9ybc3a6yvs1ppvrcn7x";
  };

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
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
