{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  matplotlib,
  numpy,
  pytestCheckHook,
  pythonOlder,
  requests,
  scipy,
  seaborn,
  setuptools,
}:

buildPythonPackage rec {
  pname = "simpful";
  version = "2.12.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aresio";
    repo = "simpful";
    tag = version;
    hash = "sha256-NtTw7sF1WfVebUk1wHrM8FHAe3/FXDcMApPkDbw0WXo=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    numpy
    scipy
    requests
  ];

  optional-dependencies = {
    plotting = [
      matplotlib
      seaborn
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "simpful" ];

  meta = with lib; {
    description = "Library for fuzzy logic";
    homepage = "https://github.com/aresio/simpful";
    changelog = "https://github.com/aresio/simpful/releases/tag/${version}";
    license = with licenses; [ lgpl3Only ];
    maintainers = with maintainers; [ fab ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
