{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  urwid,
}:

buildPythonPackage rec {
  pname = "urwidtrees";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pazz";
    repo = "urwidtrees";
    rev = "refs/tags/${version}";
    hash = "sha256-yGSjwagCd5TiwEFtF6ZhDuVqj4PTa5pVXhs8ebr2O/g=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/pazz/urwidtrees/commit/ed39dbc4fc67b0e0249bf108116a88cd18543aa9.patch";
      hash = "sha256-fA+30d2uVaoNCg4rtoWLNPvrZtq41Co4vcmM80hkURs=";
    })
  ];

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ urwid ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "urwidtrees" ];

  meta = with lib; {
    description = "Tree widgets for urwid";
    homepage = "https://github.com/pazz/urwidtrees";
    changelog = "https://github.com/pazz/urwidtrees/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = [ ];
  };
}
