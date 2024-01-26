{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, gobject-introspection
, intltool
, wrapGAppsHook
, procps
, python3
, readline
}:

stdenv.mkDerivation rec {
  pname = "scanmem";
  version = "0.17";

  src = fetchFromGitHub {
    owner  = "scanmem";
    repo   = "scanmem";
    rev    = "v${version}";
    sha256 = "17p8sh0rj8yqz36ria5bp48c8523zzw3y9g8sbm2jwq7sc27i7s9";
  };

  nativeBuildInputs = [ autoreconfHook gobject-introspection intltool wrapGAppsHook ];
  buildInputs = [ readline python3 ];
  configureFlags = ["--enable-gui"];

  # we don't need to wrap the main executable, just the GUI
  dontWrapGApps = true;

  fixupPhase = ''
    runHook preFixup

    # replace the upstream launcher which does stupid things
    # also add procps because it shells out to `ps` and expects it to be procps
    makeWrapper ${python3}/bin/python3 $out/bin/gameconqueror \
      "''${gappsWrapperArgs[@]}" \
      --set PYTHONPATH "${python3.pkgs.makePythonPath [ python3.pkgs.pygobject3 ]}" \
      --prefix PATH : "${procps}/bin" \
      --add-flags "$out/share/gameconqueror/GameConqueror.py"

    runHook postFixup
  '';

  meta = with lib; {
    homepage = "https://github.com/scanmem/scanmem";
    description = "Memory scanner for finding and poking addresses in executing processes";
    maintainers = [ ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
