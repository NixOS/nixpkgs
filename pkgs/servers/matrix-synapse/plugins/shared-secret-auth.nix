<<<<<<< HEAD
{ lib, buildPythonPackage, fetchFromGitHub, matrix-synapse-unwrapped, twisted }:
=======
{ lib, buildPythonPackage, fetchFromGitHub, matrix-synapse, twisted }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildPythonPackage rec {
  pname = "matrix-synapse-shared-secret-auth";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "devture";
    repo = "matrix-synapse-shared-secret-auth";
    rev = version;
    sha256 = "sha256-qzXKwTEOMtdvsxoU3Xh3vQyhK+Q18LfkeSts7EyDIXE=";
  };

  doCheck = false;
  pythonImportsCheck = [ "shared_secret_authenticator" ];

<<<<<<< HEAD
  buildInputs = [ matrix-synapse-unwrapped ];
=======
  buildInputs = [ matrix-synapse ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [ twisted ];

  meta = with lib; {
    description = "Shared Secret Authenticator password provider module for Matrix Synapse";
    homepage = "https://github.com/devture/matrix-synapse-shared-secret-auth";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ sumnerevans ];
  };
}
