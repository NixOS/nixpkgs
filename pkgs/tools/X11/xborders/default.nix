{ lib
, python3Packages
, fetchFromGitHub
, libwnck
, gtk3
, libnotify
, wrapGAppsHook
, gobject-introspection
, substituteAll
}:

python3Packages.buildPythonPackage rec {
  pname = "xborders";
  version = "3.4"; # in version.txt

  src = fetchFromGitHub {
    owner = "deter0";
    repo = "xborder";
    rev = "e74ae532b9555c59d195537934fa355b3fea73c5";
    hash = "sha256-UKsseNkXest6npPqJKvKL0iBWeK+S7zynrDlyXIOmF4=";
  };

  buildInputs = [
    libwnck
    gtk3
    libnotify
  ];

  nativeBuildInputs = [
    wrapGAppsHook
    gobject-introspection
  ];

  propagatedBuildInputs = with python3Packages; [
    pycairo
    requests
    pygobject3
  ];

  postPatch = let
    setup = substituteAll {
      src = ./setup.py;
      desc = meta.description; # "description" is reserved
      inherit pname version;
    };
  in ''
    ln -s ${setup} setup.py
  '';

  meta = with lib; {
    description = "Active window border replacement for window managers";
    homepage = "https://github.com/deter0/xborder";
    license = licenses.unlicense;
    maintainers = with maintainers; [ elnudev ];
    platforms = platforms.linux;
    mainProgram = "xborders";
  };
}
