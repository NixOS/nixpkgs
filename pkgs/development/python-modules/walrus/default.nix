{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pkgs,
  pythonOlder,
  redis,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "walrus";
  version = "0.9.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "coleifer";
    repo = "walrus";
    rev = "refs/tags/${version}";
    hash = "sha256-cvoRiaGGTpZWfSE6DDT6GwDmc/TC/Z/E76Qy9Zzkpsw=";
  };

  build-system = [ setuptools ];

  dependencies = [ redis ];

  nativeCheckInputs = [ unittestCheckHook ];

  preCheck = ''
    ${pkgs.redis}/bin/redis-server &
    REDIS_PID=$!
  '';

  postCheck = ''
    kill $REDIS_PID
  '';

  pythonImportsCheck = [ "walrus" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Lightweight Python utilities for working with Redis";
    homepage = "https://github.com/coleifer/walrus";
    changelog = "https://github.com/coleifer/walrus/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
