{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, markupsafe
, babel
, pytestCheckHook
, email-validator
, pythonOlder
}:

buildPythonPackage rec {
  pname = "wtforms";
  version = "3.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "wtforms";
    inherit version;
    hash = "sha256-XlHfivmmD2vurXXvoQl16XdoglqCFGplx8v1uRWZBiA=";
  };

  nativeBuildInputs = [
    hatchling
  ];

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
