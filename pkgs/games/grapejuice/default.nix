{ lib
, fetchFromGitLab
, gobject-introspection
, pciutils
, python3Packages
, gtk3
, wrapGAppsHook
, glib
, cairo
, desktop-file-utils
, xdg-utils
, xdg-user-dirs
, gettext
, winetricks
, wine
, glxinfo
, xrandr
, bash
}:

python3Packages.buildPythonApplication rec  {
  pname = "grapejuice";
  version = "7.14.4";

  src = fetchFromGitLab {
    owner = "BrinkerVII";
    repo = "grapejuice";
    rev = "v${version}";
    hash = "sha256-CWTnofJXx9T/hGXx3rdephXHjpiVRdFEJQ1u2v6n7yo=";
  };

  nativeBuildInputs = [
    gobject-introspection
    desktop-file-utils
    glib
    wrapGAppsHook
    python3Packages.pip
  ];

  buildInputs = [
    cairo
    gettext
    gtk3
    bash
  ];

  propagatedBuildInputs = with python3Packages; [
    psutil
    dbus-python
    pygobject3
    packaging
    wheel
    setuptools
    requests
    unidecode
    click
    pydantic
  ];

  dontWrapGApps = true;

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ xdg-user-dirs wine winetricks pciutils glxinfo xrandr ]}"
    # make xdg-open overrideable at runtime
    "--suffix PATH : ${lib.makeBinPath [ xdg-utils ]}"
  ];

  postPatch = ''
    substituteInPlace src/grapejuice_common/assets/desktop/grapejuice.desktop \
      --replace \$GRAPEJUICE_EXECUTABLE "$out/bin/grapejuice" \
      --replace \$GRAPEJUICE_GUI_EXECUTABLE "$out/bin/grapejuice-gui" \
      --replace \$GRAPEJUICE_ICON grapejuice

    substituteInPlace src/grapejuice_common/assets/desktop/roblox-player.desktop \
      --replace \$GRAPEJUICE_EXECUTABLE "$out/bin/grapejuice" \
      --replace \$PLAYER_ICON "grapejuice-roblox-player"

    substituteInPlace src/grapejuice_common/assets/desktop/roblox-app.desktop \
      --replace \$GRAPEJUICE_EXECUTABLE "$out/bin/grapejuice" \
      --replace \$PLAYER_ICON "grapejuice-roblox-player"

    substituteInPlace src/grapejuice_common/assets/desktop/roblox-studio.desktop src/grapejuice_common/assets/desktop/roblox-studio-auth.desktop \
      --replace \$GRAPEJUICE_EXECUTABLE "$out/bin/grapejuice" \
      --replace \$STUDIO_ICON "grapejuice-roblox-studio"

    substituteInPlace src/grapejuice_common/paths.py \
      --replace 'return local_share() / "locale"' 'return Path("${placeholder "out"}/share/locale")'

    substituteInPlace src/grapejuice_common/models/settings_model.py \
      --replace 'default_wine_home: Optional[str] = ""' 'default_wine_home: Optional[str] = "${wine}"'

    substituteInPlace src/grapejuice_packaging/builders/linux_package_builder.py \
      --replace '"--no-dependencies",' '"--no-dependencies", "--no-build-isolation",'

    substituteInPlace src/grapejuice_packaging/packaging_resources/bin/grapejuice src/grapejuice_packaging/packaging_resources/bin/grapejuice-gui \
      --replace "/usr/bin/env python3" "${python3Packages.python.interpreter}"
  '';

  installPhase = ''
    runHook preInstall

    PYTHONPATH=$(pwd)/src:$PYTHONPATH python3 -m grapejuice_packaging linux_package

    mkdir -p "$out" "$out/${python3Packages.python.sitePackages}"
    tar -xvf ./dist/linux_package/grapejuice-''${version}.tar.gz --strip-components=1 -C "$out"

    mv "$out/lib/python3/dist-packages/"* "$out/${python3Packages.python.sitePackages}"
    rmdir --ignore-fail-on-non-empty -p "$out/lib/python3/dist-packages"

    runHook postInstall
  '';

  postFixup = ''
    patchShebangs "$out/bin/grapejuice{,-gui}"

    buildPythonPath "$out $pythonPath"

    for bin in grapejuice grapejuice-gui; do
    wrapProgram "$out/bin/$bin" \
      --prefix PYTHONPATH : "$PYTHONPATH:$(toPythonPath $out)" \
      ''${makeWrapperArgs[@]} \
      ''${gappsWrapperArgs[@]}
    done
  '';

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "grapejuice" ];

  meta = with lib; {
    homepage = "https://gitlab.com/brinkervii/grapejuice";
    description = "Simple Wine+Roblox management tool";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ artturin helium ];
  };
}
