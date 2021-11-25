{ lib
, buildPythonPackage
, fetchFromGitHub
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinxext-opengraph";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "wpilibsuite";
    repo = "sphinxext-opengraph";
    rev = "v${version}";
    sha256 = "0iri6sh6h7l1p8xg04bj3bphs1hwxh43sfnrv1c8b1wy84w988y9";
  };

  propagatedBuildInputs = [
    sphinx
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "sphinxext.opengraph" ];

  meta = with lib; {
    description = "Sphinx extension to generate unique OpenGraph metadata";
    homepage = "https://github.com/wpilibsuite/sphinxext-opengraph";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
