{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "steamodd";
  version = "4.23";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b95b288a8249937b9183539eef76563a6b1df286a1db04f25141e46d8814eae9";
  };

  # tests require API key
  doCheck = false;

  pythonImportsCheck = [
    "steam.api"
    "steam.apps"
    "steam.items"
    "steam.loc"
    "steam.remote_storage"
    "steam.sim"
    "steam.user"
    "steam.vdf"
  ];

  meta = {
    description = "High level Steam API implementation with low level reusable core";
    homepage = "https://github.com/Lagg/steamodd";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
