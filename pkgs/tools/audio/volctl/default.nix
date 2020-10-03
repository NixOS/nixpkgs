{ stdenv, fetchFromGitHub, pythonPackages, libpulseaudio, glib, gtk3, gobject-introspection, wrapGAppsHook }:

pythonPackages.buildPythonApplication rec {
  pname = "volctl";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "buzz";
    repo = pname;
    rev = "v${version}";
    sha256 = "02scfscf4mdrphzrd7cbwbhpig9bhvaws8qk4zc81z8vvf3mcfv2";
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
