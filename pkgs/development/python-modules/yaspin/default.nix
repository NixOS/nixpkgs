{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  termcolor,
}:

buildPythonPackage rec {
  pname = "yaspin";
  version = "3.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pavdmyt";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-cYTCJyHZ9yNg6BfpZ+g3P0yMWFhYUxgYtlbANNgfohQ=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ termcolor ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  # tests assert for \033 which gets turned off in termcolor when TERM dumb is used which is used by nix
  preCheck = ''
    export FORCE_COLOR=1
  '';

  pythonImportsCheck = [ "yaspin" ];

  meta = with lib; {
    description = "Yet Another Terminal Spinner";
    homepage = "https://github.com/pavdmyt/yaspin";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
