{ lib, buildPythonApplication, fetchFromGitHub
, gtk3, wrapGAppsHook3, gst_all_1, gobject-introspection
, python3Packages, adwaita-icon-theme }:

buildPythonApplication {
  pname = "gscrabble";
  version = "unstable-2020-04-21";

  src = fetchFromGitHub {
    owner = "RaaH";
    repo = "gscrabble";
    rev = "aba37f062a6b183dcc084c453f395af1dc437ec8";
    sha256 = "sha256-rYpPHgOlPRnlA+Nkvo/J+/8/vl24/Ssk55fTq9oNCz4=";
  };

  doCheck = false;

  nativeBuildInputs = [ wrapGAppsHook3 gobject-introspection ];

  buildInputs = with gst_all_1; [
    gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugins-bad
    adwaita-icon-theme gtk3
  ];

  propagatedBuildInputs = with python3Packages; [ gst-python pygobject3 ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$out/share/GScrabble/modules"
      )
  '';

  meta = with lib; {
    # Fails to build, propably incompatible with latest Python
    # error: Multiple top-level packages discovered in a flat-layout
    # https://github.com/RaaH/gscrabble/issues/13
    broken = true;
    description = "Golden Scrabble crossword puzzle game";
    homepage = "https://github.com/RaaH/gscrabble/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ onny ];
  };
}
