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
<<<<<<< HEAD
, bash
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

python3Packages.buildPythonApplication rec  {
  pname = "grapejuice";
<<<<<<< HEAD
  version = "7.20.11";
=======
  version = "7.8.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "BrinkerVII";
    repo = "grapejuice";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-sDw67Xseeak1v5x0daznfdeNQahDTj21AVvXmuZlsgg=";
=======
    sha256 = "sha256-jNh3L6JDuJryFpHQaP8UesBmepmJopoHxb/XUfOwZz4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    gobject-introspection
    desktop-file-utils
    glib
    wrapGAppsHook
<<<<<<< HEAD
    python3Packages.pip
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    cairo
    gettext
    gtk3
<<<<<<< HEAD
    bash
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
    "\${gappsWrapperArgs[@]}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
    substituteInPlace src/grapejuice_common/assets/desktop/roblox-studio.desktop src/grapejuice_common/assets/desktop/roblox-studio-auth.desktop \
=======
    substituteInPlace src/grapejuice_common/assets/desktop/roblox-studio.desktop \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      --replace \$GRAPEJUICE_EXECUTABLE "$out/bin/grapejuice" \
      --replace \$STUDIO_ICON "grapejuice-roblox-studio"

    substituteInPlace src/grapejuice_common/paths.py \
      --replace 'return local_share() / "locale"' 'return Path("${placeholder "out"}/share/locale")'

    substituteInPlace src/grapejuice_common/models/settings_model.py \
      --replace 'default_wine_home: Optional[str] = ""' 'default_wine_home: Optional[str] = "${wine}"'
<<<<<<< HEAD

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
=======
  '';

  postInstall = ''
    mkdir -p "$out/share/icons" "$out/share/applications" "$out/share/mime/packages"
    cp -r src/grapejuice_common/assets/desktop/* $out/share/applications/
    cp -r src/grapejuice_common/assets/icons $out/share/
    cp src/grapejuice_common/assets/mime_xml/*.xml $out/share/mime/packages/

    # compile locales (*.po -> *.mo)
    # from https://gitlab.com/brinkervii/grapejuice/-/blob/master/src/grapejuice_common/util/mo_util.py
    LOCALE_DIR="$out/share/locale"
    PO_DIR="src/grapejuice_common/assets/po"
    LINGUAS_FILE="src/grapejuice_common/assets/po/LINGUAS"

    for lang in $(<"$LINGUAS_FILE") # extract langs from LINGUAS_FILE
    do
      po_file="$PO_DIR/$lang.po"
      mo_file_dir="$LOCALE_DIR/$lang/LC_MESSAGES"

      mkdir -p $mo_file_dir

      mo_file="$mo_file_dir/grapejuice.mo"
      msgfmt $po_file -o $mo_file # msgfmt from gettext
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
