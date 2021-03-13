{ buildPythonPackage, fetchFromGitHub, twisted }:

buildPythonPackage rec {
  pname = "matrix-synapse-shared-secret-auth";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "devture";
    repo = "matrix-synapse-shared-secret-auth";
    rev = version;
    sha256 = "0cnxp3bp8mmk01a0g3lzgvaawyywjg754j4nb9iwkmm3c2nqvnpz";
  };

  doCheck = false;
  pythonImportsCheck = [ "shared_secret_authenticator" ];

  propagatedBuildInputs = [ twisted ];
}
