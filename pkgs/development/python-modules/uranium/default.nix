{ lib, buildPythonPackage, fetchFromGitHub, python, cmake
, pyqt5, numpy, scipy, shapely, libarcus, cryptography, doxygen, gettext, pythonOlder }:

buildPythonPackage rec {
  version = "5.0.0";
  pname = "uranium";
  format = "other";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "Uranium";
    rev = version;
    sha256 = "0y98psfi5d982v941mh2jj3ln5wdsybmbz36wmh4lvgr67bdmdbf";
  };

  disabled = pythonOlder "3.5.0";

  buildInputs = [ python gettext ];
  propagatedBuildInputs = [ pyqt5 numpy scipy shapely libarcus cryptography ];
  nativeBuildInputs = [ cmake doxygen ];

  postPatch = ''
    sed -i \
     -e "s,Resources.addSearchPath(os.path.join(os.path.abspath(os.path.dirname(__file__)).*,Resources.addSearchPath(\"$out/share/uranium/resources\")," \
     -e "s,self._plugin_registry.addPluginLocation(os.path.join(os.path.abspath(os.path.dirname(__file__)).*,self._plugin_registry.addPluginLocation(\"$out/lib/uranium/plugins\")," \
     UM/Application.py
  '';

  cmakeFlags = [
    # The upstream code checks for an exact python version and errors out
    # if we don't have that and do not pass `Python_VERSION` explicitly:
    #     https://github.com/Ultimaker/Uranium/commit/21409e7b0af35bd61b13167b655345db5f481423#diff-1e7de1ae2d059d21e1dd75d5812d5a34b0222cef273b7c3a2af62eb747f9d20aR16
    "-DPython_VERSION=${python.pythonVersion}"
    # Set install location to not be the global Python install dir
    # (which is read-only in the nix store); see:
    "-DPython_SITELIB_LOCAL=${placeholder "out"}/${python.sitePackages}"
  ];

  meta = with lib; {
    description = "A Python framework for building Desktop applications";
    homepage = "https://github.com/Ultimaker/Uranium";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar gebner ];
  };
}
