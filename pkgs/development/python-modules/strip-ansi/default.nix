{
  lib,
  fetchpatch,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "strip-ansi";
  version = "0.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XWDyOcyKN/3VK0PD5m6JPUW6BCMRXbWeyg0u74Owdyk=";
  };

  patches = [
    # Replace `poetry` with `poetry-core`. Unreleased.
    # See: https://github.com/NixOS/nixpkgs/issues/103325
    (fetchpatch {
      url = "https://github.com/gwennlbh/python-strip-ansi/commit/0ea9b418d5b21bd3d3b1b3b91fad7e66f25acb97.diff";
      hash = "sha256-Pzlc7fx4kEmM8pezu+8K7z5oV44uq/rzeByqKxHVKx0=";
    })
  ];

  build-system = [
    poetry-core
  ];

  pythonImportsCheck = [
    "strip_ansi"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Strip ANSI escape sequences from a string";
    homepage = "https://pypi.org/project/strip-ansi";
    # License is in the repository but not in PyPI metadata.
    # See: https://github.com/gwennlbh/python-strip-ansi/blob/master/LICENSE
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers._9999years ];
  };
}
