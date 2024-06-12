{
  lib,
  buildPythonPackage,
  fetchPypi,
  ncurses,
  x256,
}:

buildPythonPackage rec {
  pname = "unicurses";
  version = "3.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "Uni-Curses";
    hash = "sha256-ZJUKWxu2cQlFGN1RNtyDacwSOtBiUKzk9SIDD0IQiuU=";
  };

  propagatedBuildInputs = [ x256 ];

  # Necessary because ctypes.util.find_library does not find the ncurses libraries
  postPatch = ''
    substituteInPlace './unicurses/__init__.py' \
      --replace "find_library('ncursesw')" '"${ncurses}/lib/libncursesw.so.6"' \
      --replace "find_library('panelw')" '"${ncurses}/lib/libpanelw.so.6"'
  '';

  pythonImportsCheck = [ "unicurses" ];

  meta = with lib; {
    description = "Unified Curses Wrapper for Python";
    homepage = "https://github.com/unicurses/unicurses";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ michaelBelsanti ];
  };
}
