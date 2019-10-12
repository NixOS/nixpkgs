{ stdenv, python, buildPythonPackage, fetchPypi, makeDesktopItem, jedi, pycodestyle,
  psutil, pyflakes, rope, pylint, keyring, numpydoc,
  qtconsole, qtawesome, nbconvert, mccabe, pyopengl, pygments,
  spyder-kernels, qtpy, pyzmq, chardet
, pyqtwebengine
}:


let

spyderWithPackages = select: buildPythonPackage rec {
  pname = "spyder";
  version = "3.3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1z7qw1h3rhca12ycv8xrzw6z2gf81v0j6lfq9kpwh472w4vk75v1";
  };

  propagatedBuildInputs = [
    jedi pycodestyle psutil pyflakes rope pylint keyring
    numpydoc qtconsole qtawesome nbconvert mccabe pyopengl spyder-kernels
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

  # Remove dependency on pyqtwebengine (still part of pyqt 5.11 version we have in nixpkgs)
  # Drop unneeded (cautionary) upstream limit on Qt version as we have newer
  # Exec python with the user specified package set (#70986)
  postPatch = ''
    sed -i /pyqtwebengine/d setup.py
    substituteInPlace setup.py --replace "pyqt5<5.13" "pyqt5"
    substituteInPlace spyder/utils/misc.py --replace "return executable" "return '${(python.withPackages select).interpreter}'"
  '';

  # Create desktop item
  postInstall = ''
    mkdir -p $out/share/icons
    cp spyder/images/spyder.svg $out/share/icons
    cp -r $desktopItem/share/applications/ $out/share
  '';

  # Provide a withPackages to expand the IPython package set
  passthru = {
    withPackages = select': spyderWithPackages (packages: select packages ++ select' packages);
  };

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
  };
};

in spyderWithPackages (packages: with packages; [ spyder-kernels ])
