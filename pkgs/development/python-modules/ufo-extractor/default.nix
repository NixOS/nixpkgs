{
  lib,
  buildPythonPackage,
  setuptools,
  setuptools-scm,
  fonttools,
  fontfeatures,
  fetchPypi,
}:
buildPythonPackage rec {
  pname = "ufo-extractor";
  version = "0.8.1";
  pyproject = true;

  src = fetchPypi {
    pname = "ufo_extractor";
    inherit version;
    extension = "zip";
    hash = "sha256-5MK6NFjcwO4gOjoW2Ibzc25Qw2taTpBrl+XcxIbhhj0=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    fonttools
    fontfeatures
  ];

  meta = with lib; {
    description = "Tools for extracting data from font binaries into UFO objects.";
    homepage = "https://github.com/robotools/extractor";
    license = licenses.mit;
    maintainers = with maintainers; [
      qb114514
    ];
  };
}
