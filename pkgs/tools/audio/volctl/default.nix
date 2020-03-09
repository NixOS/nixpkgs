{ stdenv, fetchFromGitHub, pythonPackages, libpulseaudio, glib, gtk3, gobject-introspection, wrapGAppsHook }:

pythonPackages.buildPythonApplication rec {
  pname = "volctl";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "buzz";
    repo = pname;
    rev = version;
    sha256 = "1bqq5mrpi7qxzl37z6fj67pqappjmwhi8d8db95j3lmf16svm2xk";
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

  postPatch = ''
    # The user can set a mixer application in the preferences. The
    # default is pavucontrol. Do not hard code its path and hope it
    # can be found in $PATH.

    substituteInPlace volctl/app.py --replace /usr/bin/pavucontrol pavucontrol
  '';

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
    homepage = https://buzz.github.io/volctl/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
