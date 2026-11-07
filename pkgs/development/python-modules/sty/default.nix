{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  poetry-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "sty";
  version = "1.0.6";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-1D7Lcbe60LVtYiyyGdC+MDwW/LQUO4TRRl3tIuKbqgA=";
  };

  nativeBuildInputs = [ poetry-core ];

  doCheck = false;

  meta = with lib; {
    description = "String styling for your terminal";
    homepage = "https://github.com/feluxe/sty";
    license = licenses.mit;
    maintainers = with maintainers; [ alikaansun ];
  };
})
