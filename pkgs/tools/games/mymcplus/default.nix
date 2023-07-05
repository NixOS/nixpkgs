{ lib
, fetchFromSourcehut
, pythonPackages
, wrapGAppsHook
}:

pythonPackages.buildPythonApplication rec {
  pname = "mymcplus";
  version = "3.0.5";

  src = fetchFromSourcehut {
    owner = "~thestr4ng3r";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GFReOgM8zi5oyePpJm5HxtizUVqqUUINTRwyG/LGWB8=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
  ];

  propagatedBuildInputs = with pythonPackages; [
    pyopengl
    wxPython_4_2
  ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~thestr4ng3r/mymcplus";
    description = "A PlayStation 2 memory card manager";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
