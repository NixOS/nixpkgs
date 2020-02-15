{ stdenv, buildPythonPackage, fetchPypi, makeDesktopItem, jedi, pycodestyle,
  psutil, pyflakes, rope, numpy, scipy, matplotlib, pylint, keyring, numpydoc,
  qtconsole, qtawesome, nbconvert, mccabe, pyopengl, cloudpickle, pygments,
  spyder-kernels_0_5_2, qtpy, pyzmq, chardet
, pyqtwebengine
}:

buildPythonPackage rec {
  pname = "spyder";
  version = "3.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fa5yhw0sjk5qydydp76scyxd8lvyciknq0vajnq0mxhhvfig3ra";
  };

  nativeBuildInputs = [ pyqtwebengine.wrapQtAppsHook ];

  propagatedBuildInputs = [
    jedi pycodestyle psutil pyflakes rope numpy scipy matplotlib pylint keyring
    numpydoc qtconsole qtawesome nbconvert mccabe pyopengl cloudpickle spyder-kernels_0_5_2
    pygments qtpy pyzmq chardet pyqtwebengine
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
    maintainers = with maintainers; [ marcus7070 gebner ];
  };
}
