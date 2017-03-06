{ stdenv, lib, fetchFromGitHub, python, cmake, pyqt5, numpy, scipy, libarcus }:

if lib.versionOlder python.version "3.5.0"
then throw "Uranium not supported for interpreter ${python.executable}"
else

stdenv.mkDerivation rec {
  name = "uranium-${version}";
  version = "2.4.0";
  
  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "Uranium";
    rev = version;
    sha256 = "1jpl0ryk8xdppillk5wzr2415n50cpa09shn1xqj6y96fg22l2il";
  };
  
  buildInputs = [ python ];
  propagatedBuildInputs = [ pyqt5 numpy scipy libarcus ];
  nativeBuildInputs = [ cmake ];

  postPatch = ''
    sed -i 's,/python''${PYTHON_VERSION_MAJOR}/dist-packages,/python''${PYTHON_VERSION_MAJOR}.''${PYTHON_VERSION_MINOR}/site-packages,g' CMakeLists.txt
    sed -i \
     -e "s,Resources.addSearchPath(os.path.join(os.path.abspath(os.path.dirname(__file__)).*,Resources.addSearchPath(\"$out/share/uranium/resources\")," \
     -e "s,self._plugin_registry.addPluginLocation(os.path.join(os.path.abspath(os.path.dirname(__file__)).*,self._plugin_registry.addPluginLocation(\"$out/lib/uranium/plugins\")," \
     UM/Application.py
  '';

  meta = with stdenv.lib; {
    description = "A Python framework for building Desktop applications";
    homepage = "https://github.com/Ultimaker/Uranium";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
