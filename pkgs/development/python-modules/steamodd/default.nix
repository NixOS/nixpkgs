{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "steamodd";
  version = "5.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Lagg";
    repo = "steamodd";
    rev = "refs/tags/v${version}";
    hash = "sha256-ySAyCOI1ISuBQ/5+UHSQVji76ZDRGjdVwlBAY9tnSmE=";
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
