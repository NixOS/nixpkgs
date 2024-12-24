{
  lib,
  buildPythonPackage,
  fetchpatch2,
  fetchPypi,
  isPy27,
  pytestCheckHook,
  pytest-cov-stub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "venusian";
  version = "3.1.0";
  pyproject = true;

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-63LNym8xOaFdyA+cldPBD4pUoLqIHu744uxbQtPuOpU=";
  };

  patches = [
    # https://github.com/Pylons/venusian/pull/92
    (fetchpatch2 {
      name = "python313-compat.patch";
      url = "https://github.com/Pylons/venusian/pull/92/commits/000b36d6968502683615da618afc3677ec8f05fc.patch?full_index=1";
      hash = "sha256-lH4x3Fc7odV+j/sHw48BDjaZAXo+WN20omnpKPNiF7w=";
    })
  ];

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Library for deferring decorator actions";
    homepage = "https://pylonsproject.org/";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };
}
