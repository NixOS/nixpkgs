{ lib, buildPythonPackage, fetchFromGitHub, matrix-synapse-unwrapped, twisted }:

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

  buildInputs = [ matrix-synapse-unwrapped ];
  propagatedBuildInputs = [ twisted ];

  meta = with lib; {
    description = "Shared Secret Authenticator password provider module for Matrix Synapse";
    homepage = "https://github.com/devture/matrix-synapse-shared-secret-auth";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ sumnerevans ];
  };
}
