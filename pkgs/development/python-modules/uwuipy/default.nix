{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "uwuipy";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Cuprum77";
    repo = "uwuipy";
    # https://github.com/Cuprum77/uwuipy/issues/14
    rev = "faa2857cded0b7174c956b56d432f6e99f155d71";
    hash = "sha256-IpiJFq1IF32klGXgEHy/4rYbInMGetPqZnsc8FVizkw=";
  };

  build-system = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "uwuipy" ];

  meta = {
    description = "Allows the easy implementation of uwuifying words for applications like Discord bots and websites";
    homepage = "https://github.com/Cuprum77/uwuipy/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
