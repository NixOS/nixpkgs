{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, makeDesktopItem
, atomicwrites
, chardet
, cloudpickle
, cookiecutter
, diff-match-patch
, flake8
, intervaltree
, jedi
, jellyfish
, keyring
, matplotlib
, mccabe
, nbconvert
, numpy
, numpydoc
, psutil
, pygments
, pylint
, pyls-spyder
, pyopengl
, pyqtwebengine
, python-lsp-black
, python-lsp-server
, pyxdg
, pyzmq
, pycodestyle
, qdarkstyle
, qstylizer
, qtawesome
, qtconsole
, qtpy
, rope
, Rtree
, scipy
, spyder-kernels
, textdistance
, three-merge
, watchdog
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "spyder";
  version = "5.3.2";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-KJkamNMXr4Mi9Y6B7aKExoiqWKoExCFlELChCrQL6mQ=";
  };

  nativeBuildInputs = [ pyqtwebengine.wrapQtAppsHook ];

  propagatedBuildInputs = [
    atomicwrites
    chardet
    cloudpickle
    cookiecutter
    diff-match-patch
    flake8
    intervaltree
    jedi
    jellyfish
    keyring
    matplotlib
    mccabe
    nbconvert
    numpy
    numpydoc
    psutil
    pygments
    pylint
    pyls-spyder
    pyopengl
    pyqtwebengine
    python-lsp-black
    python-lsp-server
    pyxdg
    pyzmq
    pycodestyle
    qdarkstyle
    qstylizer
    qtawesome
    qtconsole
    qtpy
    rope
    Rtree
    scipy
    spyder-kernels
    textdistance
    three-merge
    watchdog
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
    categories = [ "Development" "IDE" ];
  };

  postPatch = ''
    # remove dependency on pyqtwebengine
    # this is still part of the pyqt 5.11 version we have in nixpkgs
    sed -i /pyqtwebengine/d setup.py
    substituteInPlace setup.py \
      --replace "ipython>=7.31.1,<8.0.0" "ipython"
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
