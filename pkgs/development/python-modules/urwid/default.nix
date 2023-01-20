{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
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

  patches = [
    # https://github.com/urwid/urwid/pull/517
    (fetchpatch {
      name = "python311-compat.patch";
      url = "https://github.com/urwid/urwid/commit/42c1ed1eeb663179b265bae9b384d7ec11c8a9b5.patch";
      hash = "sha256-Oz8O/M6AdqbB6C/BB5rtxp8FgdGhZUxkSxKIyq5Dmho=";
    })
  ];

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
