<<<<<<< HEAD
{ fetchFromGitea
, meson
, ninja
, pkg-config
, scdoc
, gobject-introspection
, lib
, libayatana-appindicator
, libnotify
, python3Packages
=======
{ buildPythonApplication
, fetchPypi
, gobject-introspection
, gtk3
, lib
, libappindicator-gtk3
, libnotify
, click
, dbus-python
, ewmh
, pulsectl
, pygobject3
, pyxdg
, setproctitle
, python3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, procps
, xset
, xautolock
, xscreensaver
, xfce
<<<<<<< HEAD
, wrapGAppsHook
}:

python3Packages.buildPythonApplication rec {
  pname = "caffeine-ng";
  version = "4.2.0";
  format = "other";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "WhyNotHugo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uYzLRZ+6ZgIwhSuJWRBpLYHgonX7sFXgUZid0V26V0Q=";
  };

  nativeBuildInputs = [ gobject-introspection meson ninja pkg-config wrapGAppsHook ];

  buildInputs = [
    libayatana-appindicator
    libnotify
  ];

  pythonPath = with python3Packages; [
    click
=======
, glib
, setuptools-scm
, wrapGAppsHook
}:

let
  click_7 = click.overridePythonAttrs (old: rec {
    version = "7.1.2";
    src = old.src.override {
      inherit version;
      hash = "sha256-0rUlXHxjSbwb0eWeCM0SrLvWPOZJ8liHVXg6qU37axo=";
    };
  });
in buildPythonApplication rec {
  pname = "caffeine-ng";
  version = "4.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-umIjXJ0et6Pi5Ejj96Q+ZhiKS+yj7bsgb4uQW6Ym6rU=";
  };

  nativeBuildInputs = [ wrapGAppsHook glib gobject-introspection setuptools-scm ];

  buildInputs = [
    libappindicator-gtk3
    libnotify
    gtk3
  ];

  pythonPath = [
    click_7
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    dbus-python
    ewmh
    pulsectl
    pygobject3
<<<<<<< HEAD
    scdoc
    setproctitle
  ];

  dontWrapGApps = true;

  patches = [
    ./fix-build.patch
  ];

  postPatch = ''
    echo "${version}" > version
  '';

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
=======
    pyxdg
    setproctitle
  ];

  doCheck = false; # There are no tests.
  dontWrapGApps = true;
  strictDeps = false;

  postInstall = ''
    cp -r share $out/
    cp -r caffeine/assets/icons $out/share/

    # autostart file
    ln -s $out/${python3.sitePackages}/etc $out/etc

    glib-compile-schemas --strict $out/share/glib-2.0/schemas
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ procps xautolock xscreensaver xfce.xfconf xset ]}
    )
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    mainProgram = "caffeine";
    maintainers = with maintainers; [ marzipankaiser ];
    description = "Status bar application to temporarily inhibit screensaver and sleep mode";
    homepage = "https://codeberg.org/WhyNotHugo/caffeine-ng";
<<<<<<< HEAD
    changelog = "https://codeberg.org/WhyNotHugo/caffeine-ng/src/tag/v${version}/CHANGELOG.rst";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
