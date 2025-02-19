{
  buildPythonPackage,
  colormath,
  fetchFromGitHub,
  fetchpatch2,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "spectra";
  version = "0.0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jsvine";
    repo = "spectra";
    tag = "v${version}";
    hash = "sha256-4A2TWTxYqckJ3DX5cd2KN3KXcmO/lQdXmOEnGi76RsA=";
  };

  patches = [
    # https://github.com/jsvine/spectra/pull/21
    (fetchpatch2 {
      name = "nose-to-pytest.patch";
      url = "https://github.com/jsvine/spectra/commit/50037aba16dac4bf0fb7ffbd787d0e6b906e8a4b.patch";
      hash = "sha256-cMoIbjRwcZjvhiIOcJR7NmIAOaqpr/e5eh9+sPGKqos=";
      excludes = [ ".github/*" ];
    })
  ];

  build-system = [
    setuptools
  ];

  propagatedBuildInputs = [ colormath ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Python library that makes color math, color scales, and color-space conversion easy";
    homepage = "https://github.com/jsvine/spectra";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ apraga ];
  };
}
