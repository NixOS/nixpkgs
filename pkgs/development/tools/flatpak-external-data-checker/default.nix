{ lib
, fetchFromGitHub
, python3
, unstableGitUpdater
}:

python3.pkgs.buildPythonApplication {
  pname = "flatpak-external-data-checker";
  version = "0-unstable-2023-04-27";

  format = "other";

  src = fetchFromGitHub {
    owner = "flathub";
    repo = "flatpak-external-data-checker";
    rev = "4766d06d7af38d0b749c1975a9938ec6dd9ea138";
    hash = "sha256-mMnjbUf9/A6HCBbNT0+n7unt+kq3Rb2vIWmJ6JG6j+E=";
  };

  buildInputs = [
    python3
  ];

  pythonPath = with python3.pkgs; [
    pygobject3
    requests
    pygithub
    ruamel-yaml
    toml
    pyelftools
    aiohttp
    semver
    jsonschema
    editorconfig
    lxml
    packaging
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    datadir="$out/share/flatpak-external-data-checker"
    mkdir -p "$out/bin" "$datadir"

    cp -r \
      canonicalize-manifest \
      flatpak-external-data-checker \
      src/ \
      "$datadir"

    ln -s "$datadir/canonicalize-manifest" "$datadir/flatpak-external-data-checker" "$out/bin"

    runHook postInstall
  '';

  postFixup = ''
    # Prevent Python modules from being accidentally wrapped.
    find "$datadir/src" -type f -executable -exec chmod -x '{}' ';'

    # Wrap the entry points.
    wrapPythonProgramsIn "$datadir" "$out $pythonPath"
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = with lib; {
    description = "Tool for checking if the external data used in Flatpak manifests is still up to date";
    homepage = "https://github.com/flathub/flatpak-external-data-checker";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
