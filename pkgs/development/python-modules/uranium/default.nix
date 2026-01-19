{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  cmake,
  pyqt5,
  numpy,
  scipy,
  shapely,
  libarcus,
  cryptography,
  doxygen,
  gettext,
}:

buildPythonPackage rec {
  version = "4.12.0";
  pname = "uranium";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "Uranium";
    rev = version;
    hash = "sha256-SE9xqrloPXIRTJiiqUdRKFmb4c0OjmJK5CMn6VXMFmk=";
  };

  buildInputs = [
    python
    gettext
  ];
  propagatedBuildInputs = [
    pyqt5
    numpy
    scipy
    shapely
    libarcus
    cryptography
  ];
  nativeBuildInputs = [
    cmake
    doxygen
  ];

  postPatch = ''
    sed -i 's,/python''${PYTHON_VERSION_MAJOR}/dist-packages,/python''${PYTHON_VERSION_MAJOR}.''${PYTHON_VERSION_MINOR}/site-packages,g' CMakeLists.txt
    sed -i \
     -e "s,Resources.addSearchPath(os.path.join(os.path.abspath(os.path.dirname(__file__)).*,Resources.addSearchPath(\"$out/share/uranium/resources\")," \
     -e "s,self._plugin_registry.addPluginLocation(os.path.join(os.path.abspath(os.path.dirname(__file__)).*,self._plugin_registry.addPluginLocation(\"$out/lib/uranium/plugins\")," \
     UM/Application.py
  '';

  meta = {
    description = "Python framework for building Desktop applications";
    homepage = "https://github.com/Ultimaker/Uranium";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
