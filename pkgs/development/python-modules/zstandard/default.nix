{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  cffi,
  setuptools,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zstandard";
  version = "0.25.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dxPhF50WLPXHkG2oduwsy5w6ncvf/vDMf3DDZnogXws=";
  };

  build-system = [
    cffi
    setuptools
  ];

  dependencies = lib.optionals isPyPy [ cffi ];

  # python-zstandard depends on unstable zstd C APIs and may break with version mismatches,
  # so we don't provide system zstd for this package
  # https://github.com/indygreg/python-zstandard/blob/9eb56949b1764a166845e065542690942a3203d3/c-ext/backend_c.c#L137-L150

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  preCheck = ''
    rm -r zstandard
  '';

  pythonImportsCheck = [ "zstandard" ];

  meta = {
    description = "Zstandard bindings for Python";
    homepage = "https://github.com/indygreg/python-zstandard";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ arnoldfarkas ];
  };
}
