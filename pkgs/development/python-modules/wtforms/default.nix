{ lib
, buildPythonPackage
, fetchPypi
, markupsafe
, babel
, pytestCheckHook
, email-validator
}:

buildPythonPackage rec {
  version = "3.0.1";
  pname = "wtforms";

  src = fetchPypi {
    pname = "WTForms";
    inherit version;
    sha256 = "1g654ghavds387hqxmhg9s8x222x89wbq1ggzxbsyn6x2axindbb";
  };

  propagatedBuildInputs = [ markupsafe babel ];


  checkInputs = [
    pytestCheckHook
    email-validator
  ];

  pythonImportsCheck = [ "wtforms" ];

  meta = with lib; {
    description = "A flexible forms validation and rendering library for Python";
    homepage = "https://github.com/wtforms/wtforms";
    changelog = "https://github.com/wtforms/wtforms/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = [ maintainers.bhipple ];
  };

}
