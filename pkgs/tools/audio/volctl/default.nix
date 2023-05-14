{ lib, python3Packages, fetchFromGitHub, wrapGAppsHook, gobject-introspection, libpulseaudio, glib, gtk3, pango, xorg }:

python3Packages.buildPythonApplication rec {
  pname = "volctl";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "buzz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ill0rwqrgAH7lbzh86DQc1Q71lkYh8PCKZvi4XadsW8=";
  };

  postPatch = ''
    substituteInPlace volctl/xwrappers.py \
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
    pulsectl
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

  meta = with lib; {
    description = "PulseAudio enabled volume control featuring per-app sliders";
    homepage = "https://buzz.github.io/volctl/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
