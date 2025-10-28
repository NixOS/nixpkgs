{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  setuptools-scm,
  cffi,
  pytestCheckHook,
  pytest-mock,
  pkgs, # only for cmph
}:

buildPythonPackage rec {
  pname = "swh-perfecthash";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-perfecthash";
    tag = "v${version}";
    hash = "sha256-cG0h0lfSSooA7Mzrlsi5yIcbkbxQZ7mI5NtiB7D5Crs=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    cffi
    pkgs.cmph
  ];

  # The installed library clashes with the `swh` directory remaining in the source path.
  # Usually, we get around this by `rm -rf` the python source files to ensure that the installed package is used.
  # Here, we cannot do that as it would also remove the tests which are also in the `swh` directory.
  preCheck = ''
    rm -rf swh/perfecthash/*.py
  '';

  pythonImportsCheck = [ "swh.perfecthash" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  disabledTests = [
    # Flake tests
    "test_build_speed"
  ];

  meta = {
    description = "Perfect hash table for software heritage object storage";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-perfecthash";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
}
