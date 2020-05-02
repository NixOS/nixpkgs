{ stdenv, buildPythonPackage, fetchFromGitHub, jedi, pycodestyle,
  psutil, pyflakes, rope, pylint, keyring, numpydoc,
  qtconsole, qtawesome, nbconvert, mccabe, pyopengl, cloudpickle, pygments,
  spyder-kernels_0_5, qtpy, pyzmq, chardet, pyqtwebengine
}:

buildPythonPackage rec {
  pname = "spyder";
  version = "3.3.6";

  src = fetchFromGitHub {
    owner = "spyder-ide";
    repo = "spyder";
    rev = "v3.3.6";
    sha256 = "1sk9xajhzpklk5bcbdhpfhx3gxhyrahsmj9bv2m6kvbqxdlx6bq6";
  };

  propagatedBuildInputs = [
    jedi pycodestyle psutil pyflakes rope pylint keyring numpydoc 
    qtconsole qtawesome nbconvert mccabe pyopengl cloudpickle spyder-kernels_0_5
    pygments qtpy pyzmq chardet pyqtwebengine
  ];

  # tests fail with a segfault
  doCheck = false;

  postPatch = ''
    # remove dependency on pyqtwebengine
    # this is still part of the pyqt 5.13 version we have in nixpkgs
    sed -i /pyqtwebengine/d setup.py
    substituteInPlace setup.py --replace "pyqt5<5.13" "pyqt5"
  '';

  meta = with stdenv.lib; {
    description = "Library providing a scientific python development environment";
    longDescription = ''
      Spyder (previously known as Pydee) is a powerful interactive development
      environment for the Python language with advanced editing, interactive
      testing, debugging and introspection features.
    '';
    homepage = "https://github.com/spyder-ide/spyder/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gebner marcus7070 ];
  };
}
