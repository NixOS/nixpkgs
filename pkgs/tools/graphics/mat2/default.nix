{ stdenv
, poppler_gi
, gdk_pixbuf
, librsvg
, ffmpeg
, exiftool
, python3
, gobject-introspection
, wrapGAppsHook
}:

let
  inherit (python3.pkgs) mutagen pygobject3 pycairo buildPythonApplication fetchPypi;
in buildPythonApplication rec {
  pname = "mat2";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "beb99965eb41ebe022b6abed941aa0d23882e26b4b4b48f94295911a637f90ff";
  };

  # avoids AttributeError: module 'libmat2.archive' has no attribute 'ZipParser'
  doCheck = false;

  nativeBuildInputs = [ wrapGAppsHook ];
  propagatedBuildInputs = [
    mutagen
    pycairo
    pygobject3
    librsvg
    ffmpeg
    exiftool
    gobject-introspection
    poppler_gi
    gdk_pixbuf
  ];

  meta = {
    description = "metadata removal tool supporting a wide range of commonly used file formats";
    homepage = "https://0xacab.org/jvoisin/mat2";
    license = stdenv.lib.licenses.gpl3;
    platforms = python3.meta.platforms;
    maintainers = with stdenv.lib.maintainers; [ Dallos ];
  };
}


