{ lib
, buildPythonPackage
, fetchPypi
, pkginfo
, requests
, requests_toolbelt
, tqdm
, pyblake2
, readme_renderer
}:

buildPythonPackage rec {
  pname = "twine";
  version = "1.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d89bc6acafb31d124e6e5b295ef26ac77030bf098960c2a4c4e058335827c5c";
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
