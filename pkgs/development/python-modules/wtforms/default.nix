{ lib
, buildPythonPackage
, fetchPypi
, markupsafe
, babel
, pytestCheckHook
, email-validator
, pythonOlder
}:

buildPythonPackage rec {
  pname = "wtforms";
  version = "3.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "WTForms";
    inherit version;
    hash = "sha256-azUbuxLdWK9X/+8FvHhCXQjRkU4P1o7hQUO3reAjxbw=";
  };

  propagatedBuildInputs = [
    markupsafe
    babel
  ];

  passthru.optional-dependencies = {
    email = [
      email-validator
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "wtforms"
  ];

  meta = with lib; {
    description = "A flexible forms validation and rendering library for Python";
    homepage = "https://github.com/wtforms/wtforms";
    changelog = "https://github.com/wtforms/wtforms/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bhipple ];
  };

}
