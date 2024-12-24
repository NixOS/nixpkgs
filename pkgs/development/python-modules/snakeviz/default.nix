{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ipython,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
  tornado,
}:

buildPythonPackage rec {
  pname = "snakeviz";
  version = "2.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jiffyclub";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-tW1zUfCgOGQ8TjrKo2lBzGb0MSe25dP0/P9Q6x3736E=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ tornado ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    ipython
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [ "snakeviz" ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  meta = with lib; {
    description = "Browser based viewer for profiling data";
    mainProgram = "snakeviz";
    homepage = "https://jiffyclub.github.io/snakeviz";
    changelog = "https://github.com/jiffyclub/snakeviz/blob/v${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nixy ];
  };
}
