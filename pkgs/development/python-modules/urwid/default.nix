{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, glibcLocales
}:

buildPythonPackage rec {
  pname = "urwid";
  version = "2.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "588bee9c1cb208d0906a9f73c613d2bd32c3ed3702012f51efe318a3f2127eae";
  };

  # tests need to be able to set locale
  LC_ALL = "en_US.UTF-8";
  checkInputs = [ glibcLocales ];

  # tests which assert on strings don't decode results correctly
  doCheck = isPy3k;

  pythonImportsCheck = [
    "urwid"
  ];

  meta = with lib; {
    description = "A full-featured console (xterm et al.) user interface library";
    homepage = "https://urwid.org/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
