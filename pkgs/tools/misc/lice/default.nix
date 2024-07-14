{ lib, buildPythonPackage, fetchPypi , setuptools, pytestCheckHook }:

buildPythonPackage rec {
  pname = "lice";
  version = "0.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LZU2YPdJiepaCH/TWNrtJiuyPlJP6t1+c3a2uHL0fmo=";
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
