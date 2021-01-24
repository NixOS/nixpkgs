{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "matrix-synapse-rest-password-provider";
  version = "unstable-2020-08-02";

  src = fetchFromGitHub {
    owner = "ma1uta";
    repo = pname;
    rev = "c782c84aeab1872e73b6c29aadb99d3852e26bbd";
    sha256 = "0v9900d6919yq05s08ihrc8jclpaixfm8mwi60vhxalmddgwlhjy";
  };

  meta = with lib; {
    homepage = "https://github.com/ma1uta/matrix-synapse-rest-password-provider";
    description = "Synapse password provider which allows you to validate a password for a given username and return a user profile using an existing backend";
    maintainers = teams.matrix.members;
    license = licenses.agpl3Only;
  };
}
