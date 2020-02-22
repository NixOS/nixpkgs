{ stdenv, buildPythonPackage, fetchPypi, makeDesktopItem, intervaltree, jedi, pycodestyle,
  psutil, pyflakes, rope, numpy, scipy, matplotlib, pylint, keyring, numpydoc,
  qtconsole, qtawesome, nbconvert, mccabe, pyopengl, cloudpickle, pygments,
  spyder-kernels, qtpy, pyzmq, chardet, qdarkstyle, watchdog, python-language-server
, pyqtwebengine
}:

buildPythonPackage rec {
  pname = "spyder";
  version = "4.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4b279c16487d224368dd2213e1517185fa59fc528f539601fffb34ea97accb7b";
  };

  nativeBuildInputs = [ pyqtwebengine.wrapQtAppsHook ];

  propagatedBuildInputs = [
    intervaltree jedi pycodestyle psutil pyflakes rope numpy scipy matplotlib pylint keyring
    numpydoc qtconsole qtawesome nbconvert mccabe pyopengl cloudpickle spyder-kernels
    pygments qtpy pyzmq chardet pyqtwebengine qdarkstyle watchdog python-language-server
  ];

  # There is no test for spyder
  doCheck = false;

  desktopItem = makeDesktopItem {
    name = "Spyder";
    exec = "spyder";
    icon = "spyder";
    comment = "Scientific Python Development Environment";
    desktopName = "Spyder";
    genericName = "Python IDE";
    categories = "Application;Development;Editor;IDE;";
  };

  postPatch = ''
    # remove dependency on pyqtwebengine
    # this is still part of the pyqt 5.11 version we have in nixpkgs
    sed -i /pyqtwebengine/d setup.py
    substituteInPlace setup.py --replace "pyqt5<5.13" "pyqt5"
  '';

  # Create desktop item
  postInstall = ''
    mkdir -p $out/share/icons
    cp spyder/images/spyder.svg $out/share/icons
    cp -r $desktopItem/share/applications/ $out/share
  '';

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with stdenv.lib; {
    description = "Scientific python development environment";
    longDescription = ''
      Spyder (previously known as Pydee) is a powerful interactive development
      environment for the Python language with advanced editing, interactive
      testing, debugging and introspection features.
    '';
    homepage = "https://github.com/spyder-ide/spyder/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gebner ];
    broken = true;
  };
}
