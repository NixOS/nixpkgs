{ lib
, buildPythonPackage
, fetchPypi
, substituteAll
, supervise
, isPy3k
, whichcraft
, util-linux
}:

buildPythonPackage rec {
  pname = "supervise_api";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1230f42294910e83421b7d3b08a968d27d510a4a709e966507ed70db5da1b9de";
  };

  patches = [
    (substituteAll {
      src = ./supervise-path.patch;
      inherit supervise;
    })
  ];

  # In the git repo, supervise_api lives inside a python subdir
  patchFlags = [ "-p2" ];

  propagatedBuildInputs = lib.optional (!isPy3k) whichcraft;

  nativeCheckInputs = [ util-linux ];

  meta = {
    description = "An API for running processes safely and securely";
    homepage = "https://github.com/catern/supervise";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ catern ];
  };
}
