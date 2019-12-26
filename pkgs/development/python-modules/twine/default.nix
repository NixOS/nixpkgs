{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pkginfo
, requests
, requests_toolbelt
, tqdm
, pyblake2
, readme_renderer
}:

buildPythonPackage rec {
  pname = "twine";
  version = "2.0.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9fe7091715c7576df166df8ef6654e61bada39571783f2fd415bdcba867c6993";
  };

  propagatedBuildInputs = [ pkginfo requests requests_toolbelt tqdm pyblake2 readme_renderer ];

  # Requires network
  doCheck = false;

  meta = {
    description = "Collection of utilities for interacting with PyPI";
    homepage = https://github.com/pypa/twine;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
