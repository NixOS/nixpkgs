{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, pytestCheckHook
, certvalidator, pyasn1, pyasn1-modules
}:

buildPythonPackage rec {
  pname = "signify";
  version = "0.3.0";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "ralphje";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JxQECpwHhPm8TCVW/bCnEpu5I/WETyZVBx29SQE4NmE=";
  };
  patches = [
    # Upstream patch is available here:
    #  https://github.com/ralphje/signify/commit/8c345be954e898a317825bb450bed5ba0304b2b5.patch
    # But update a couple other things and dont apply cleanly. This is an extract of the part
    # we care about and breaks the tests after 2021-03-01
    ./certificate-expiration-date.patch
  ];

  propagatedBuildInputs = [ certvalidator pyasn1 pyasn1-modules ];

  checkInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "-v" ];
  pythonImportsCheck = [ "signify" ];

  meta = with lib; {
    homepage = "https://github.com/ralphje/signify";
    description = "library that verifies PE Authenticode-signed binaries";
    license = licenses.mit;
    maintainers = with maintainers; [ baloo ];
  };
}
