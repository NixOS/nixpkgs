{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "setproctitle";
  version = "1.1.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6283b7a58477dd8478fbb9e76defb37968ee4ba47b05ec1c053cb39638bd7398";
  };

  meta = with stdenv.lib; {
    description = "Allows a process to change its title (as displayed by system tools such as ps and top)";
    homepage =  https://github.com/dvarrazzo/py-setproctitle;
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ exi ];
  };

}
