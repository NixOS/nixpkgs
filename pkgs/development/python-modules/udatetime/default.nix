{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "udatetime";
  version = "0.0.17";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "udatetime";
    inherit (finalAttrs) version;
    hash = "sha256-sQvFVwaZpDinLitaZOdr2MKO4779FvIJOHpVB/oLgwE=";
  };

  build-system = [ setuptools ];

  # tests not included on pypi
  doCheck = false;

  pythonImportsCheck = [ "udatetime" ];

  meta = {
    description = "Fast RFC3339 compliant Python date-time library";
    mainProgram = "bench_udatetime.py";
    homepage = "https://github.com/freach/udatetime";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
