{ lib
, pkgs
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, redis
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "walrus";
  version = "0.9.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "coleifer";
    repo = "walrus";
    rev = "refs/tags/${version}";
    hash = "sha256-jinYMGSBAY8HTg92qU/iU5vGIrrDr5SeQG0XjsBVfcc=";
  };

  propagatedBuildInputs = [
    redis
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  preCheck = ''
    ${pkgs.redis}/bin/redis-server &
    REDIS_PID=$!
  '';

  postCheck = ''
    kill $REDIS_PID
  '';

  pythonImportsCheck = [
    "walrus"
  ];

  meta = with lib; {
    description = "Lightweight Python utilities for working with Redis";
    homepage = "https://github.com/coleifer/walrus";
    changelog = "https://github.com/coleifer/walrus/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
