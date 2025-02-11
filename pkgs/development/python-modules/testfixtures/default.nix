{
  lib,
  buildPythonPackage,
  fetchpatch2,
  fetchPypi,
  mock,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  sybil,
  twisted,
}:

buildPythonPackage rec {
  pname = "testfixtures";
  version = "8.3.0";
  pyproject = true;
  # DO NOT CONTACT upstream.
  # https://github.com/simplistix/ is only concerned with internal CI process.
  # Any attempt by non-standard pip workflows to comment on issues will
  # be met with hostility.
  # https://github.com/simplistix/testfixtures/issues/169
  # https://github.com/simplistix/testfixtures/issues/168

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1MC4SvLyZ2EPkIAJtQ1vmDpOWK3iLGe6tnh7WkAtWcA=";
  };

  patches = [
    (fetchpatch2 {
      name = "python313-compat.patch";
      url = "https://github.com/simplistix/testfixtures/commit/a23532c7bc685589cce6a5037821a74da48959e7.patch?full_index=1";
      hash = "sha256-k0j/WgA+6LNTYJ233GJjeRU403bJJRxbpOu+BUsMeyQ=";
    })
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    sybil
    twisted
  ];

  disabledTestPaths = [
    # Django is too much hasle to setup at the moment
    "testfixtures/tests/test_django"
  ];

  pytestFlagsArray = [ "testfixtures/tests" ];

  pythonImportsCheck = [ "testfixtures" ];

  meta = with lib; {
    description = "Collection of helpers and mock objects for unit tests and doc tests";
    homepage = "https://github.com/Simplistix/testfixtures";
    changelog = "https://github.com/simplistix/testfixtures/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
