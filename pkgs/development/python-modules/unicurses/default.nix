{
  lib,
  buildPythonPackage,
  fetchPypi,
  ncurses,
  x256,
}:

buildPythonPackage rec {
  pname = "unicurses";
  version = "3.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "Uni-Curses";
    hash = "sha256-M4mjdmy2NSf5KiTVYznPy86bVgZB5u1vDi6GIH1Frc4=";
  };

  propagatedBuildInputs = [ x256 ];

  # Necessary because ctypes.util.find_library does not find the ncurses libraries
  postPatch = ''
    substituteInPlace './unicurses/__init__.py' \
      --replace-fail "find_library('ncursesw')" '"${ncurses}/lib/libncursesw.so.6"' \
      --replace-fail "find_library('panelw')" '"${ncurses}/lib/libpanelw.so.6"'
  '';

  pythonImportsCheck = [ "unicurses" ];

  meta = with lib; {
    description = "Unified Curses Wrapper for Python";
    homepage = "https://github.com/unicurses/unicurses";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ michaelBelsanti ];
  };
}
