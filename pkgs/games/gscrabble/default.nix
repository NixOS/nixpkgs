{ stdenv, buildPythonApplication, fetchFromGitHub
, gtk3, wrapGAppsHook, gst_all_1, gobject-introspection
, python3Packages, gnome3, hicolor-icon-theme }:

buildPythonApplication {
  pname = "gscrabble";
  version = "unstable-2019-03-11";

  src = fetchFromGitHub {
    owner = "RaaH";
    repo = "gscrabble";
    rev = "4b6e4e151a4cd4a4f66a5be2c8616becac3f2a29";
    sha256 = "0a89kqh04x52q7qyv1rfa7xif0pdw3zc0dw5a24msala919g90q2";
  };

  doCheck = false;

  nativeBuildInputs = [ wrapGAppsHook ];

  buildInputs = with gst_all_1; [
    gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugins-bad
    hicolor-icon-theme gnome3.adwaita-icon-theme gtk3 gobject-introspection
  ];

  propagatedBuildInputs = with python3Packages; [ gst-python pygobject3 ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$out/share/GScrabble/modules"
      )
  '';

  meta = with stdenv.lib; {
    description = "Golden Scrabble crossword puzzle game";
    homepage = https://github.com/RaaH/gscrabble/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.genesis ];
  };
}
