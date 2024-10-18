{
  lib,
  buildPythonPackage,
  fetchPypi,
  substituteAll,
  setuptools,
  setuptools-scm,
  filelock,
  requests,
  unicode-character-database,
}:

buildPythonPackage rec {
  pname = "youseedee";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9w6yr28zq0LgOvMp5fCFaHGOwK4wbbDo/g1jH4Uky0E=";
  };

  patches = [
    # Load data files from the unicode-character-database package instead of
    # downloading them from the internet. (nixpkgs-specific, not upstreamable)
    (substituteAll {
      src = ./0001-use-packaged-unicode-data.patch;
      ucd_dir = "${unicode-character-database}/share/unicode";
    })
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    filelock
    requests
  ];

  # Package has no unit tests, but we can check an example as per README.rst:
  checkPhase = ''
    runHook preCheck
    python -m youseedee 0x078A | grep -qE "Block\s+Thaana"
    runHook postCheck
  '';

  meta = with lib; {
    description = "Python library for querying the Unicode Character Database";
    homepage = "https://github.com/simoncozens/youseedee";
    license = licenses.mit;
    maintainers = with maintainers; [ danc86 ];
  };
}
