{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "wazeroutecalculator";
  version = "0.16";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-tJip0tSlwr7a5UVH77dAPNHag4v1JShU1vHA9xKhbwg=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # there are no tests
  doCheck = false;

  pythonImportsCheck = [ "WazeRouteCalculator" ];

  meta = {
    description = "Calculate actual route time and distance with Waze API";
    homepage = "https://github.com/kovacsbalu/WazeRouteCalculator";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
})
