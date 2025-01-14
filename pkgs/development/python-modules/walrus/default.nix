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
    tag = version;
    hash = "sha256-cvoRiaGGTpZWfSE6DDT6GwDmc/TC/Z/E76Qy9Zzkpsw=";
  };

  build-system = [ setuptools ];

  dependencies = [ redis ];

  nativeCheckInputs = [ unittestCheckHook ];

  preCheck = ''
    # Note for Darwin: unless the output is redirected, the parent process becomes launchd.
    # In case of a test failure, that prevents killing the Redis process,
    # hanging the build forever (that would happen before postCheck).
    ${pkgs.redis}/bin/redis-server >/dev/null 2>&1 &
    REDIS_PID=$!
    MAX_RETRIES=30
    RETRY_COUNT=0
    until ${pkgs.redis}/bin/redis-cli --scan || [ $RETRY_COUNT -eq $MAX_RETRIES ]; do
      echo "Waiting for redis to be ready"
      sleep 1
      RETRY_COUNT=$((RETRY_COUNT + 1))
    done
    if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
      echo "Redis failed to start after $MAX_RETRIES retries"
      exit 1
    fi
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
