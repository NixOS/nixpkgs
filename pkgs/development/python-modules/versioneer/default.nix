{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "versioneer";
  version = "0.20";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Ljk2AOwnF7efWcmE942TX3bkbEyu+HWoe4tO1gLy/2U=";
  };

  # Couldn't get tests to work because, for instance, they used virtualenv and
  # pip.
  doCheck = false;

  pythonImportsCheck = [ "versioneer" ];

  meta = with lib; {
    description = "Version-string management for VCS-controlled trees";
    homepage = "https://github.com/warner/python-versioneer";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ jluttine ];
  };
}
