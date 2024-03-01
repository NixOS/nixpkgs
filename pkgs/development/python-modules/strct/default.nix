{ lib
, fetchFromGitHub
, fetchpatch
, buildPythonPackage
, setuptools
, pytestCheckHook
, sortedcontainers
}:

buildPythonPackage rec {
  pname = "strct";
  version = "0.0.32";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "shaypal5";
    repo = "strct";
    rev = "v${version}";
    hash = "sha256-ctafvdfSOdp7tlCUYg7d5XTXR1qBcWvOVtGtNUnhYIw=";
  };

  patches = [
    # https://github.com/shaypal5/strct/pull/4
    (fetchpatch {
      name = "fix-versioneer-on-python312.patch";
      url = "https://github.com/shaypal5/strct/commit/a1e5b6ca9045b52efdfdbb3c82e12a01e251d41b.patch";
      hash = "sha256-xXADCSIhq1ARny2twzrhR1J8LkMFWFl6tmGxrM8RvkU=";
    })
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace  \
        "--cov" \
        "#--cov"

    # configure correct version, which fails due to missing .git
    substituteInPlace versioneer.py strct/_version.py \
      --replace '"0+unknown"' '"${version}"'
  '';

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    sortedcontainers
  ];

  pythonImportsCheck = [
    "strct"
    "strct.dicts"
    "strct.hash"
    "strct.lists"
    "strct.sets"
    "strct.sortedlists"
  ];

  meta = with lib; {
    description = "A small pure-python package for data structure related utility functions";
    homepage = "https://github.com/shaypal5/strct";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
