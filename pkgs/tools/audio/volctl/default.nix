{ stdenv, fetchFromGitHub, pythonPackages, libpulseaudio, glib, gtk3, gobject-introspection, wrapGAppsHook }:

pythonPackages.buildPythonApplication rec {
  pname = "volctl";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "buzz";
    repo = pname;
    rev = version;
    sha256 = "0rppqc5wiqxd83z2mgvhi6gdx7yhy9wnav1dbbi1wvm7lzw6fnil";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    libpulseaudio
  ];

  pythonPath = with pythonPackages; [
    pygobject3
  ];

  strictDeps = false;

  preBuild = ''
    export LD_LIBRARY_PATH=${libpulseaudio}/lib
  '';

  preFixup = ''
    glib-compile-schemas ${glib.makeSchemaPath "$out" "${pname}-${version}"}

    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${libpulseaudio}/lib"
    )
  '';

  meta = with stdenv.lib; {
    description = "PulseAudio enabled volume control featuring per-app sliders";
    homepage = "https://buzz.github.io/volctl/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
