{
  lib,
  buildPythonPackage,
  fetchPypi,
  jellyfish,
  pytestCheckHook,
  pytz,
  setuptools,
}:

buildPythonPackage rec {
  pname = "us";
  version = "4.0.0";
  pyproject = true;

  build-system = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fdTE5gPJQnty1+B75wDY9kO9zX9RlaErxjnxt+OOdJY=";
  };

  propagatedBuildInputs = [
    jellyfish
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
  ];

  pythonImportsCheck = [ "us" ];

  meta = {
    description = "Package for easily working with US and state metadata";
    mainProgram = "states";
    longDescription = ''
      All US states and territories, postal abbreviations, Associated Press style
      abbreviations, FIPS codes, capitals, years of statehood, time zones, phonetic
      state name lookup, is contiguous or continental, URLs to shapefiles for state,
      census, congressional districts, counties, and census tracts.
    '';
    homepage = "https://github.com/unitedstates/python-us/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
  };
}
