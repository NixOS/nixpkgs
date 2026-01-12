{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pyyaml,
  jinja2,
  mock,
  fetchpatch2,
  pytestCheckHook,
  distutils,
}:

buildPythonPackage rec {
  pname = "webassets";
  version = "2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FnEyM3Z3yM7clwUJD21I2j+yYsjgsnc7KfM1LwUBgc0=";
  };

  patches = [
    # remove nose and extra mock
    (fetchpatch2 {
      name = "remove-nose-and-mock.patch";
      url = "https://github.com/miracle2k/webassets/commit/26e203929eebbb4cdbb9967cf47fefa95df8f24d.patch?full_index=1";
      hash = "sha256-+jrMT6Sl/MOLkleUEDZkzRd5tzBTXZYNoCXRrTFVtq4=";
      excludes = [
        "requirements-dev.pip"
        "tox.ini"
      ];
    })
    (fetchpatch2 {
      name = "fix-missing-zope-skip.patch";
      url = "https://github.com/miracle2k/webassets/commit/3bfb5ea8223c46c60b922fdbbda36d9b8c5e9c9c.patch?full_index=1";
      hash = "sha256-dV8bp6vYr56mZpzw5C7ac4rXri04o4MrAhwfWUXLe4s=";
    })
    ./migrate_test_setup_to_pytest.patch
  ];

  build-system = [ setuptools ];

  dependencies = [ pyyaml ];

  nativeCheckInputs = [
    jinja2
    mock
    pytestCheckHook
    distutils
  ];

  postPatch = ''
    # Fix thread attribute "isAlive"
    substituteInPlace tests/test_script.py \
      --replace-fail "isAlive" "is_alive"
  '';

  disabledTests = [
    "TestFilterBaseClass"
    "TestAutoprefixer6Filter"
    "TestBabel"
  ];

  meta = {
    description = "Media asset management for Python, with glue code for various web frameworks";
    mainProgram = "webassets";
    homepage = "https://github.com/miracle2k/webassets/";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
