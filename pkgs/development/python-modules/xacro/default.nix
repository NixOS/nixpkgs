{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "xacro";
  version = "2.0.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ros";
    repo = "xacro";
    rev = version;
    hash = "sha256-L9hPAKUb4sajI7tKnCvDdWGIOo7MidtijCyLHOr8qTg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pyyaml
  ];

  pythonImportsCheck = [
    "xacro"
  ];

  meta = {
    description = "Xacro is an XML macro language. With xacro, you can construct shorter and more readable XML files by using macros that expand to larger XML expressions";
    homepage = "https://github.com/ros/xacro";
    changelog = "https://github.com/ros/xacro/blob/${src.rev}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ gwennlbh ];
  };
}
