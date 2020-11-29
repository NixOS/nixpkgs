{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "setproctitle";
  version = "1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9b4e48722dd96cbd66d5bf2eab930fff8546cd551dd8d774c8a319448bd381a6";
  };

  meta = with stdenv.lib; {
    description = "Allows a process to change its title (as displayed by system tools such as ps and top)";
    homepage =  "https://github.com/dvarrazzo/py-setproctitle";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ exi ];
  };

}
