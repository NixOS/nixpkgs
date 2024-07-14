{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "translationstring";
  version = "1.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v5R1ONduaboSqxcoOxA1Wp7PvAeOYSNEP0PyEH9jdvM=";
  };

  meta = with lib; {
    homepage = "https://pylonsproject.org/";
    description = "Utility library for i18n relied on by various Repoze and Pyramid packages";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };
}
