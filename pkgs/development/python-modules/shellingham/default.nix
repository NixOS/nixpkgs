{ lib, buildPythonPackage, fetchPypi
}:

buildPythonPackage rec {
  pname = "shellingham";
  version = "1.4.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SFXCRY1pBIKb00wpnxH97tfP77+KLFIuTK6mzXazFx4=";
  };

  meta = with lib; {
    description = "Tool to Detect Surrounding Shell";
    homepage = "https://github.com/sarugaku/shellingham";
    license = licenses.isc;
    maintainers = with maintainers; [ mbode ];
  };
}
