{
  lib,
  buildPythonPackage,
  fetchPypi,
  jellyfish,
  pytestCheckHook,
  pythonOlder,
  pytz,
  setuptools,
}:

buildPythonPackage rec {
  pname = "us";
  version = "3.2.0";
  pyproject = true;

  build-system = [ setuptools ];

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yyI+hTk9zFFx6tDdISutxH+WZ7I3AP6j5+pfMQ1UUzg=";
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
