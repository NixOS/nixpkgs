{
  lib,
  buildPythonPackage,
  fetchPypi,
  fqdn,
  jsonschema,
  rfc3987,
  strict-rfc3339,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "weblate-schemas";
  version = "2024.1";

  src = fetchPypi {
    pname = "weblate_schemas";
    inherit version;
    hash = "sha256-nYPLD3VDO1Z97HI79J6Yjj3bWp1xKB79FWPCW146iz4=";
  };

  dependencies = [
    fqdn
    jsonschema
    rfc3987
    strict-rfc3339
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "weblate_schemas" ];

  meta = with lib; {
    description = "Schemas used by Weblate";
    homepage = "https://github.com/WeblateOrg/weblate_schemas";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
  };

}
