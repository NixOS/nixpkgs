{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-xdist,
  pytestCheckHook,
  termcolor,
}:

buildPythonPackage rec {
  pname = "yaspin";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pavdmyt";
    repo = "yaspin";
    tag = "v${version}";
    hash = "sha256-4IWaAPqzGri7V8X2gL607F5GlWfIFDlBBpDwSe4sz9I=";
  };

  build-system = [ poetry-core ];

  dependencies = [ termcolor ];

  pythonRelaxDeps = [
    "termcolor"
  ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  # tests assert for \033 which gets turned off in termcolor when TERM dumb is used which is used by nix
  preCheck = ''
    export FORCE_COLOR=1
  '';

  pythonImportsCheck = [ "yaspin" ];

  meta = {
    description = "Yet Another Terminal Spinner";
    homepage = "https://github.com/pavdmyt/yaspin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ samuela ];
  };
}
