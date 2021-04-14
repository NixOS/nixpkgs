{ lib, buildPythonPackage, fetchPypi, isPy27, makeDesktopItem, intervaltree,
  jedi, pycodestyle, psutil, pyflakes, rope, numpy, scipy, matplotlib, pylint,
  keyring, numpydoc, qtconsole, qtawesome, nbconvert, mccabe, pyopengl,
  cloudpickle, pygments, spyder-kernels, qtpy, pyzmq, chardet, qdarkstyle,
  watchdog, python-language-server, pyqtwebengine, atomicwrites, pyxdg,
  diff-match-patch, three-merge, pyls-black, pyls-spyder, flake8
}:

buildPythonPackage rec {
  pname = "spyder";
  version = "4.2.4";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ec3a6949a3210f7a35142ddd0e8ec529bdd382ae0cae9d1537f2009f557214c8";
  };

  nativeBuildInputs = [ pyqtwebengine.wrapQtAppsHook ];

  propagatedBuildInputs = [
    intervaltree jedi pycodestyle psutil pyflakes rope numpy scipy matplotlib pylint keyring
    numpydoc qtconsole qtawesome nbconvert mccabe pyopengl cloudpickle spyder-kernels
    pygments qtpy pyzmq chardet pyqtwebengine qdarkstyle watchdog python-language-server
    atomicwrites pyxdg diff-match-patch three-merge pyls-black pyls-spyder
    flake8
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
    categories = "Development;IDE;";
  };

  postPatch = ''
    # remove dependency on pyqtwebengine
    # this is still part of the pyqt 5.11 version we have in nixpkgs
    sed -i /pyqtwebengine/d setup.py
    substituteInPlace setup.py \
      --replace "pyqt5<5.13" "pyqt5" \
      --replace "parso==0.7.0" "parso"
  '';

  postInstall = ''
    # add Python libs to env so Spyder subprocesses
    # created to run compute kernels don't fail with ImportErrors
    wrapProgram $out/bin/spyder --prefix PYTHONPATH : "$PYTHONPATH"

    # Create desktop item
    mkdir -p $out/share/icons
    cp spyder/images/spyder.svg $out/share/icons
    cp -r $desktopItem/share/applications/ $out/share
  '';

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Scientific python development environment";
    longDescription = ''
      Spyder (previously known as Pydee) is a powerful interactive development
      environment for the Python language with advanced editing, interactive
      testing, debugging and introspection features.
    '';
    homepage = "https://www.spyder-ide.org/";
    downloadPage = "https://github.com/spyder-ide/spyder/releases";
    changelog = "https://github.com/spyder-ide/spyder/blob/master/CHANGELOG.md";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gebner ];
  };
}
