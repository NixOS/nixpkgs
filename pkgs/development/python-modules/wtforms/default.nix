{ lib
, buildPythonPackage
, fetchPypi
, markupsafe
, Babel
, pytestCheckHook
, email_validator
}:

buildPythonPackage rec {
  version = "3.0.1";
  pname = "WTForms";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1g654ghavds387hqxmhg9s8x222x89wbq1ggzxbsyn6x2axindbb";
  };

  propagatedBuildInputs = [ markupsafe Babel ];


  checkInputs = [
    pytestCheckHook
    email_validator
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
