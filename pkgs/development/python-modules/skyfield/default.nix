{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  certifi,
  numpy,
  sgp4,
  jplephem,
  pandas,
  ipython,
  matplotlib,
  assay,
}:

buildPythonPackage rec {
  pname = "skyfield";
  version = "1.54";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "skyfielders";
    repo = "python-skyfield";
    rev = version;
    hash = "sha256-oZEmc8BVqs3eSaqrjyR/wQu1WTLv4A0a/dpEZduCXqk=";
  };

  # Fix broken tests on "exotic" platforms.
  # https://github.com/skyfielders/python-skyfield/issues/582#issuecomment-822033858
  postPatch = ''
    substituteInPlace skyfield/tests/test_planetarylib.py \
      --replace-fail "if IS_32_BIT" "if True"
  '';

  build-system = [ setuptools ];

  dependencies = [
    certifi
    numpy
    sgp4
    jplephem
  ];

  nativeCheckInputs = [
    pandas
    ipython
    matplotlib
    assay
  ];

  checkPhase = ''
    runHook preCheck

    cd ci
    assay --batch skyfield.tests

    runHook postCheck
  '';

  pythonImportsCheck = [ "skyfield" ];

  meta = {
    homepage = "https://github.com/skyfielders/python-skyfield";
    description = "Elegant astronomy for Python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zane ];
  };
}
