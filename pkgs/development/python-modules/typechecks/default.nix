{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
}:

buildPythonPackage {
  pname = "typechecks";
  version = "unstable-2023-07-13";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "openvax";
    repo = "typechecks";
    # See https://github.com/openvax/typechecks/issues/2. As of 2023-07-13,
    # they do no have version tags.
    rev = "5340b4e8a2f419b3a7aa816a5b19e2e0a6ce0679";
    hash = "sha256-GdmBtkyuzLfpk6oneWgJ5M1bnhGJ5/lSbGliwoAQWZs=";
  };

  pythonImportsCheck = [ "typechecks" ];

  meta = with lib; {
    description = "Type checking helpers for Python";
    homepage = "https://github.com/openvax/typechecks";
    license = licenses.asl20;
    maintainers = with maintainers; [ samuela ];
  };
}
