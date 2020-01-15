{ stdenv, fetchFromGitHub, pythonPackages
, gnome_python
, libappindicator-gtk2, xflux, librsvg, wrapGAppsHook
}:
pythonPackages.buildPythonApplication rec {
  pname = "xflux-gui";
  version = "1.1.10";

  src = fetchFromGitHub {
    repo = "xflux-gui";
    owner = "xflux-gui";
    rev = "v${version}";
    sha256 = "1k67qg9y4c0n9ih0syx81ixbdl2x89gd4arwh71316cshskn0rc8";
  };

  propagatedBuildInputs = with pythonPackages; [
    pexpect
    pyGtkGlade
    pygobject2
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
    wrapPythonPrograms
    patchPythonScript $out/${pythonPackages.python.sitePackages}/fluxgui/fluxapp.py
  '';

  meta = {
    description = "Better lighting for Linux. Open source GUI for xflux";
    homepage = https://justgetflux.com/linux.html;
    license = stdenv.lib.licenses.unfree; # marked as unfree since the source code contains a copy of the unfree xflux binary
    maintainers = [ stdenv.lib.maintainers.sheenobu ];
    platforms = stdenv.lib.platforms.linux;
  };
}
