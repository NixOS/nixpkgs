{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, fetchpatch
, setuptools
, requests
}:

buildPythonPackage rec {
  pname = "starline";
  version = "0.1.5";

  disabled = pythonOlder "3.5";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F1P1/NKml2rtd1r7A/g5IVnwQMZzkXzAxjRRDZXBPLk=";
  };

  patches = [
    # https://github.com/Anonym-tsk/starline/pull/5
    (fetchpatch {
      url = "https://github.com/Anonym-tsk/starline/commit/4e6cdf8e05c5fb8509ee384e77b39a2495587160.patch";
      hash = "sha256-y9b6ePH3IEgmt3ALHQGwH102rlm4KfmH4oIoIC93cWU=";
    })
  ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    requests
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "starline" ];

  # https://github.com/Anonym-tsk/starline/issues/4
  passthru.skipBulkUpdate = true;

  meta = with lib; {
    description = "Unofficial python library for StarLine API";
    homepage = "https://github.com/Anonym-tsk/starline";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
