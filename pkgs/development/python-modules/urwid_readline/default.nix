{ stdenv, buildPythonPackage, fetchPypi, pythonPackages, pytest, glibcLocales, pytestCheckHook }:

buildPythonPackage rec {
  pname = "urwid_readline";
  version = "0.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dgxd9gwh5nx93v6h3snvbagi0ykwm5jc768ifgd2h2rnza7dqr4";
  };

  checkInputs = [ pytestCheckHook glibcLocales ];

  buildInputs = with pythonPackages; [ urwid ];

  # tests need to be able to set locale
  LC_ALL = "en_US.UTF-8";

  meta = with stdenv.lib; {
    description = "A textbox edit widget for urwid that supports readline shortcuts";
    homepage = https://github.com/rr-/urwid_readline;
    repositories.git = git://github.com/rr-/urwid_readline.git;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}
