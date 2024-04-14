{ lib, buildPythonPackage, fetchPypi , setuptools, pytestCheckHook }:

buildPythonPackage rec {
  pname = "lice";
  version = "0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0skyyirbidknfdzdvsjga8zb4ar6xpd5ilvz11dfm2a9yxh3d59d";
  };

  propagatedBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];
  meta = with lib; {
    description = "Print license based on selection and user options";
    homepage = "https://github.com/licenses/lice";
    license = licenses.bsd3;
    maintainers = with maintainers; [ swflint ];
    platforms = platforms.unix;
    mainProgram = "lice";
  };

}
