{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  hjson,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "super-collections";
  version = "0.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fralau";
    repo = "super-collections";
    tag = "v${version}";
    hash = "sha256-6Pvw+xJl9p8pKvVJL5Pt5fsuW7wgk/rbNGdnl87velw=";
  };

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
    pytestCheckHook
  ];

  dependencies = [
    hjson
  ];

  pythonImportsCheck = [
    "super_collections"
  ];

  meta = {
    description = "Python SuperDictionaries (with attributes) and SuperLists";
    homepage = "https://github.com/fralau/super-collections";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marcel ];
  };
}
