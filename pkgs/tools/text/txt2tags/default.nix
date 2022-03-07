{ lib, buildPythonApplication, fetchPypi, tox }:

buildPythonApplication rec {
  pname = "txt2tags";
  version = "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12hpnvdy7dgarq6ini9jp7dp2zcmvpax04zbl3jb84kd423r75i7";
  };

  checkInputs = [ tox ];

  meta = {
    homepage = "https://txt2tags.org/";
    description = "A KISS markup language";
    license  = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ kovirobi ];
    platforms = with lib.platforms; unix;
  };
}
