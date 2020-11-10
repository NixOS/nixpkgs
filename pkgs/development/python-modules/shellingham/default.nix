{ stdenv, buildPythonPackage, fetchPypi
}:

buildPythonPackage rec {
  pname = "shellingham";
  version = "1.3.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "576c1982bea0ba82fb46c36feb951319d7f42214a82634233f58b40d858a751e";
  };

  meta = with stdenv.lib; {
    description = "Tool to Detect Surrounding Shell";
    homepage = "https://github.com/sarugaku/shellingham";
    license = licenses.isc;
    maintainers = with maintainers; [ mbode ];
  };
}
