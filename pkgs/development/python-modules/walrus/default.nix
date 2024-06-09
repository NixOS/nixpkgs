{
  lib,
  pkgs,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  redis,
  unittestCheckHook,
  fetchpatch,
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

  patches = [
    # distutils has been deprecated, this wraps its import inside a try-catch
    # and fallsback to a fallback import.
    # Should not be necessary in future versions.
    (fetchpatch {
      url = "https://github.com/coleifer/walrus/commit/79e20c89aa4015017ef8a3e0b5c27ca2731dc9b2.patch";
      hash = "sha256-hCpvki6SV3KYhicjjUMP4VrKMEerMjq2n1BgozXKDO8=";
    })
  ];

  propagatedBuildInputs = [ redis ];

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
