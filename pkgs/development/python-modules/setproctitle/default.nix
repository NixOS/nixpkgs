{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "python-setproctitle";
  version = "1.1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mqadassxcm0m9r1l02m5vr4bbandn48xz8gifvxmb4wiz8i8d0w";
  };

  meta = with stdenv.lib; {
    description = "Allows a process to change its title (as displayed by system tools such as ps and top)";
    homepage =  https://github.com/dvarrazzo/py-setproctitle;
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ exi ];
  };

}
