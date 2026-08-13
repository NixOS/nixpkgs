{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  version = "1.4";
  pname = "x11-hash";
  pyproject = true;

  src = fetchPypi {
    pname = "x11_hash";
    inherit version;
    hash = "sha256-QtzqxEzpVGK48/lvOEr8VtPUYexLdXKD3zGv1VOdWpw=";
  };

  nativeBuildInputs = [ setuptools ];

  # pypi's source doesn't include tests
  doCheck = false;

  pythonImportsCheck = [ "x11_hash" ];

  meta = {
    description = "Binding for X11 proof of work hashing";
    homepage = "https://github.com/mazaclub/x11_hash";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ np ];
  };
}
