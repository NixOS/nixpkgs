{ lib
, buildPythonPackage
, fetchPypi
, substituteAll
, filelock
, requests
, unicode-character-database
}:

buildPythonPackage rec {
  pname = "youseedee";
  version = "0.5.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hQkI8kdropLiO86LXDy6eQma3FEg48gLldU7bFg9dzI=";
  };

  patches = [
    # Load data files from the unicode-character-database package instead of
    # downloading them from the internet. (nixpkgs-specific, not upstreamable)
    (substituteAll {
      src = ./0001-use-packaged-unicode-data.patch;
      ucd_dir = "${unicode-character-database}/share/unicode";
    })
  ];

  propagatedBuildInputs = [
    filelock
    requests
  ];

  doCheck = true;
  # Package has no unit tests, but we can check an example as per README.rst:
  checkPhase = ''
    runHook preCheck
    python -m youseedee 0x078A | grep -q "'Block': 'Thaana'"
    runHook postCheck
  '';

  meta = with lib; {
    description = "Python library for querying the Unicode Character Database";
    homepage = "https://github.com/simoncozens/youseedee";
    license = licenses.mit;
    maintainers = with maintainers; [ danc86 ];
  };
}
