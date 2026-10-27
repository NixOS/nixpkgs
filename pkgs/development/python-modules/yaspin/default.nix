{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  termcolor,
}:

buildPythonPackage rec {
  pname = "yaspin";
  version = "3.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pavdmyt";
    repo = "yaspin";
    tag = "v${version}";
    hash = "sha256-KX3UrDRM5ZBRiCnKyP1OsMi1gLAq7iRb6Wl2Sz00zys=";
  };

  build-system = [ poetry-core ];

  dependencies = [ termcolor ];

  pythonRelaxDeps = [
    "termcolor"
  ];

  nativeCheckInputs = [
    pytest-mock
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
