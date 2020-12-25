{ stdenv, python3Packages, fetchFromGitHub, wrapGAppsHook, gobject-introspection, libpulseaudio, glib, gtk3, pango, xorg }:

python3Packages.buildPythonApplication rec {
  pname = "volctl";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "buzz";
    repo = pname;
    rev = "v${version}";
    sha256 = "02scfscf4mdrphzrd7cbwbhpig9bhvaws8qk4zc81z8vvf3mcfv2";
  };

  postPatch = ''
    substituteInPlace volctl/lib/xwrappers.py \
      --replace 'libXfixes.so' "${xorg.libXfixes}/lib/libXfixes.so" \
      --replace 'libXfixes.so.3' "${xorg.libXfixes}/lib/libXfixes.so.3"
  '';

  preBuild = ''
    export LD_LIBRARY_PATH=${libpulseaudio}/lib
  '';

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook
  ];

  propagatedBuildInputs = [ pango gtk3 ] ++ (with python3Packages; [
    click
    pycairo
    pygobject3
    pyyaml
  ]);

  # with strictDeps importing "gi.repository.Gtk" fails with "gi.RepositoryError: Typelib file for namespace 'Pango', version '1.0' not found"
  strictDeps = false;

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "volctl" ];

  preFixup = ''
    glib-compile-schemas ${glib.makeSchemaPath "$out" "${pname}-${version}"}
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${libpulseaudio}/lib")
  '';

  meta = with stdenv.lib; {
    description = "PulseAudio enabled volume control featuring per-app sliders";
    homepage = "https://buzz.github.io/volctl/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
