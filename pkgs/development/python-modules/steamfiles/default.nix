{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  protobuf,
  protobuf3-to-dict,
}:
buildPythonPackage {
  pname = "steamfiles";
  version = "0-unstable-2020-10-26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "twstagg";
    repo = "steamfiles";
    rev = "18bb08d5ff8b0e36d4cc14453deaf58d721339e4";
    hash = "sha256-CRzX4mKvBVYC0ayu2bq6aAzhAWPW0m737cw1gfBRj7U=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    protobuf
    protobuf3-to-dict
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = ["steamfiles"];

  meta = with lib; {
    description = "Python library for parsing the most common Steam file formats";
    homepage = "https://github.com/twstagg/steamfiles";
    license = licenses.mit;
    maintainers = with maintainers; [vinnymeller];
  };
}
