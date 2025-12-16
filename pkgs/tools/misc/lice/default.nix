{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "lice";
  version = "0.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0skyyirbidknfdzdvsjga8zb4ar6xpd5ilvz11dfm2a9yxh3d59d";
  };

  propagatedBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];
  meta = {
    description = "Print license based on selection and user options";
    homepage = "https://github.com/licenses/lice";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ swflint ];
    platforms = lib.platforms.unix;
    mainProgram = "lice";
  };

}
