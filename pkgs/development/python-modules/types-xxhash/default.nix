{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-xxhash";
  version = "3.0.5.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mfJ/CvFGvrovEIZ30reYCv6N33NZtEUYG/xxOdt2SC4=";
  };

  build-system = [
    setuptools
  ];

  meta = {
    description = "Typing stubs for xxhash";
    homepage = "https://pypi.org/project/types-xxhash";
    changelog = "https://github.com/typeshed-internal/stub_uploader/blob/main/data/changelogs/xxhash.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
