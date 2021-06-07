{ lib, buildPythonPackage, fetchPypi, isPy3k, isPy27, glibcLocales }:

buildPythonPackage rec {
  pname = "urwid";
  version = "2.1.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "588bee9c1cb208d0906a9f73c613d2bd32c3ed3702012f51efe318a3f2127eae";
  };

  # tests need to be able to set locale
  LC_ALL = "en_US.UTF-8";
  checkInputs = [ glibcLocales ];

  # tests which assert on strings don't decode results correctly
  doCheck = isPy3k;

  pythonImportsCheck = [ "urwid" ];

  meta = with lib; {
    description = "A full-featured console (xterm et al.) user interface library";
    homepage = "https://excess.org/urwid";
    repositories.git = "git://github.com/wardi/urwid.git";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ ];
  };
}
