{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch
, poetry-core
, requests
, urllib3
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "synologydsm-api";
  version = "1.0.2";

  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = "synologydsm-api";
    rev = "v${version}";
    sha256 = "0gyahf1x6i6j9pslh1y3pyh3si5jvxb06r1w761b9gsxyk14y1si";
  };

  patches = [
    # https://github.com/hacf-fr/synologydsm-api/pull/84
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/hacf-fr/synologydsm-api/commit/f1ea2be927388bdff6d43d09027b82a854635e34.patch";
      sha256 = "120pdgp2i4ds6y3rf9j372f9zdcf4y8rsgl1xjbkgdhkp76bkkgr";
    })
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    requests
    urllib3
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "synology_dsm" ];

  meta = with lib; {
    description = "Python API for communication with Synology DSM";
    homepage = "https://github.com/hacf-fr/synologydsm-api";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
