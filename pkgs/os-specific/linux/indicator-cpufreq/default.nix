{ stdenv, cpufrequtils, lib, fetchbzr, gobject-introspection
  , intltool, glib, python3, wrapGAppsHook }:

python3.pkgs.buildPythonApplication {
  name = "indicator-cpufreq-98";
  src = fetchbzr {
    url = lp:indicator-cpufreq;
    rev = "98";
    sha256 = "0h54mxqy0xi73vn3q7vx99lhry38ysfhfd5rnbcyhf5lvm4xrj8i";
  };

  patchPhase = ''
    substituteInPlace data/com.ubuntu.IndicatorCpufreqSelector.service \
      --replace /usr $out
    substituteInPlace indicator_cpufreq/cpufreq.py \
      --replace find_library\(\"cpufreq\"\) \"$(realpath ${lib.makeLibraryPath [cpufrequtils]}/libcpufreq.so)\"
  '';

  nativeBuildInputs = with python3.pkgs;  [

    distutils_extra
    intltool
    wrapGAppsHook
    #wrapPython
  ];

  propagatedBuildInputs = with python3.pkgs; [
    dbus-python pygobject3 glib gobject-introspection ];

  doCheck = false;

  meta = {
    homepage = https://launchpad.net/indicator-cpufreq;
    description = "Indicator applet for displaying and changing CPU frequency on-the-fly";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ genesis ];
    platforms = lib.platforms.linux;
  };
}
