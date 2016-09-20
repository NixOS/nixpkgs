{ stdenv, fetchFromGitHub, buildPythonPackage,
  pexpect,
  pyGtkGlade,
  pygobject,
  pyxdg,
  gnome_python,
  libappindicator-gtk2,
  xflux,
  python
}:
buildPythonPackage rec {
  name = "xflux-gui-${version}";
  version = "2016-08-08";

  src = fetchFromGitHub {
    repo = "xflux-gui";
    owner = "xflux-gui";
    rev = "4125e70b6ad0aeda7de46b3a7083a26c392555dc";
    sha256 = "1l56f59hnjyi7nn8wn3dfdx6lw2qjbrhdlcfz0qvwj6b0953f2s7";
  };

  # not sure if these need to be propagated or not?
  propagatedBuildInputs = [
    pexpect
    pyGtkGlade
    pygobject
    pyxdg
    libappindicator-gtk2
    gnome_python
  ];

  buildInputs = [
    xflux
  ];

  postPatch = ''
     substituteInPlace src/fluxgui/xfluxcontroller.py --replace "pexpect.spawn(\"xflux\"" "pexpect.spawn(\"${xflux}/bin/xflux\""
  '';

  postFixup = ''
    wrapPythonPrograms
    patchPythonScript $out/${python.sitePackages}/fluxgui/fluxapp.py
  '';

  meta = {
    description = "Better lighting for Linux. Open source GUI for xflux";
    homepage = https://justgetflux.com/linux.html;
    license = stdenv.lib.licenses.unfree; # marked as unfree since the source code contains a copy of the unfree xflux binary
    maintainers = [ stdenv.lib.maintainers.sheenobu ];
    platforms = stdenv.lib.platforms.linux;
  };
}
