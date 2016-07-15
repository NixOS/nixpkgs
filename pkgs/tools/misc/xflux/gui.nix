{ stdenv, pkgs, fetchFromGitHub, buildPythonPackage,
  pexpect,
  pyGtkGlade,
  pygobject,
  pyxdg,
  gnome_python,
}:
buildPythonPackage rec {
  version = "1.1.1";
  name = "xflux-gui-${version}";

  src = fetchFromGitHub {
    repo = "xflux-gui";
    owner = "xflux-gui";
    rev = "d897dfd";
    sha256 = "1mx1r2hz3g3waafn4w8hql0gaasfizbzz60bk5llw007k4k8892r";
  };

  # remove messing with shipped binary
  patches = [ ./setup.patch ];

  # not sure if these need to be propagated or not?
  propagatedBuildInputs = [
    pexpect
    pyGtkGlade
    pygobject
    pyxdg
    pkgs.libappindicator-gtk2
    gnome_python
  ];

  buildInputs = [
    pkgs.xflux
  ];

  postPatch = ''
     substituteInPlace src/fluxgui/xfluxcontroller.py --replace "pexpect.spawn(\"xflux\"" "pexpect.spawn(\"${pkgs.xflux}/bin/xflux\""
  '';

  meta = {
    description = "Better lighting for Linux. Open source GUI for xflux";
    homepage = https://justgetflux.com/linux.html;
    license = stdenv.lib.licenses.unfree; # marked as unfree since the source code contains a copy of the unfree xflux binary
    maintainers = [ stdenv.lib.maintainers.sheenobu ];
    platforms = stdenv.lib.platforms.linux;
  };
}
