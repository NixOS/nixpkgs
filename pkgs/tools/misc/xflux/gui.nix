{ stdenv, fetchFromGitHub, buildPythonPackage
, pexpect, pyGtkGlade, pygobject, pyxdg
, gnome_python, python
, libappindicator-gtk2, xflux, librsvg, wrapGAppsHook
}:
buildPythonPackage rec {
  name = "xflux-gui-${version}";
  version = "2016-09-21";

  src = fetchFromGitHub {
    repo = "xflux-gui";
    owner = "xflux-gui";
    rev = "0b56204477494b473a390e8b0db043437ec14f32";
    sha256 = "15pr8f31jnhqjlpvasnj6cmm6hw5gljphh2pxzav3zd9bp4yl56r";
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

  buildInputs = [ xflux librsvg ];

  nativeBuildInputs = [ wrapGAppsHook ];

  postPatch = ''
     substituteInPlace src/fluxgui/xfluxcontroller.py --replace "pexpect.spawn(\"xflux\"" "pexpect.spawn(\"${xflux}/bin/xflux\""
  '';

  postFixup = ''
    wrapGAppsHook
    makeWrapperArgs="''${gappsWrapperArgs[@]}"
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
