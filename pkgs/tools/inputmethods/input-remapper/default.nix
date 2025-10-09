{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  pkgconfig,
  wrapGAppsHook3,
  gettext,
  gtk3,
  glib,
  dbus,
  gobject-introspection,
  xmodmap,
  pygobject3,
  setuptools,
  evdev,
  pydantic,
  pydbus,
  psutil,
  procps,
  gtksourceview4,
  bash,
  udevCheckHook,
  nixosTests,
  # Change the default log level to debug for easier debugging of package issues
  withDebugLogLevel ? false,
  # Xmodmap is an optional dependency
  # If you use Xmodmap to set keyboard mappings (or your DE does)
  # it is required to correctly map keys
  withXmodmap ? true,
  # Some tests are flakey under high CPU load and could cause intermittent
  # failures when building. Override this to true to run tests anyway
  # See upstream issue: https://github.com/sezanzeb/input-remapper/issues/306
  withDoCheck ? false,
}:

let
  maybeXmodmap = lib.optional withXmodmap xmodmap;
in
(buildPythonApplication rec {
  pname = "input-remapper";
  version = "2.1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sezanzeb";
    repo = "input-remapper";
    tag = version;
    hash = "sha256-GMKcs2UK1yegGT/TBsLGgTBJROQ38M6WwnLbJIuAZwg=";
  };

  postPatch = ''
    # fix FHS paths
    substituteInPlace inputremapper/configs/data.py \
      --replace-fail "/usr/share"  "$out/usr/share"
  ''
  + lib.optionalString withDebugLogLevel ''
    # if debugging
    substituteInPlace inputremapper/logger.py \
      --replace-fail "logger.setLevel(logging.INFO)"  "logger.setLevel(logging.DEBUG)"
  '';

  nativeBuildInputs = [
    wrapGAppsHook3
    gettext # needed to build translations
    gtk3
    glib
    gobject-introspection
    pygobject3
    udevCheckHook
  ]
  ++ maybeXmodmap;

  dependencies = [
    setuptools # needs pkg_resources
    pygobject3
    evdev
    pkgconfig
    pydantic
    pydbus
    gtksourceview4
    psutil
  ];

  doCheck = withDoCheck;

  nativeCheckInputs = [ psutil ];

  pythonImportsCheck = [
    "evdev"
    "inputremapper"
  ];

  postInstall = ''
    substituteInPlace data/99-input-remapper.rules \
      --replace-fail 'RUN+="/bin/input-remapper-control' "RUN+=\"$out/bin/input-remapper-control"
    substituteInPlace data/input-remapper.service \
      --replace-fail "ExecStart=/usr/bin/input-remapper-service" "ExecStart=$out/bin/input-remapper-service"
    substituteInPlace data/input-remapper-autoload.desktop \
      --replace-fail "bash" "${lib.getExe bash}"

    install -m644 -D -t $out/share/applications/ data/*.desktop
    install -m644 -D -t $out/share/polkit-1/actions/ data/input-remapper.policy
    install -m644 -D data/99-input-remapper.rules $out/etc/udev/rules.d/99-input-remapper.rules
    install -m644 -D data/input-remapper.service $out/lib/systemd/system/input-remapper.service
    install -m644 -D data/input-remapper.policy $out/share/polkit-1/actions/input-remapper.policy
    install -m644 -D data/inputremapper.Control.conf $out/etc/dbus-1/system.d/inputremapper.Control.conf
    install -m644 -D data/input-remapper.svg $out/share/icons/hicolor/scalable/apps/input-remapper.svg
    install -m644 -D -t $out/usr/share/input-remapper/ data/*

    # Only install input-remapper prefixed binaries, we don't care about deprecated key-mapper ones
    install -m755 -D -t $out/bin/ bin/input-remapper*
  '';

  # Custom test script, can't use plain pytest / pytestCheckHook
  # We only run tests in the unit folder, integration tests require UI
  # To allow tests which access the system and session DBUS to run, we start a dbus session
  # and bind it to both the system and session buses
  installCheckPhase = ''
    runHook preInstallCheck

    echo "<busconfig>
      <type>session</type>
      <listen>unix:tmpdir=$TMPDIR</listen>
      <listen>unix:path=/build/system_bus_socket</listen>
      <standard_session_servicedirs/>
      <policy context=\"default\">
        <!-- Allow everything to be sent -->
        <allow send_destination=\"*\" eavesdrop=\"true\"/>
        <!-- Allow everything to be received -->
        <allow eavesdrop=\"true\"/>
        <!-- Allow anyone to own anything -->
        <allow own=\"*\"/>
      </policy>
    </busconfig>" > dbus.cfg
    PATH=${
      lib.makeBinPath (
        [
          dbus
          procps
        ]
        ++ maybeXmodmap
      )
    }:$PATH \
      USER="$(id -u -n)" \
      DBUS_SYSTEM_BUS_ADDRESS=unix:path=/build/system_bus_socket \
      ${dbus}/bin/dbus-run-session --config-file dbus.cfg \
      python tests/test.py --start-dir unit

    runHook postInstallCheck
  '';

  # Nixpkgs 15.9.4.3. When using wrapGAppsHook3 with special derivers you can end up with double wrapped binaries.
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PATH : "${lib.makeBinPath maybeXmodmap}"
    )
  '';

  passthru.tests = nixosTests.input-remapper;

  meta = {
    description = "Easy to use tool to change the mapping of your input device buttons";
    homepage = "https://github.com/sezanzeb/input-remapper";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ LunNova ];
    mainProgram = "input-remapper-gtk";
  };
}).overrideAttrs
  (
    final: prev: {
      # Set in an override as buildPythonApplication doesn't yet support
      # the `final:` arg yet from #119942 'overlay style overridable recursive attributes'
      # this ensures the rev matches the input src's rev after overriding
      # See https://discourse.nixos.org/t/avoid-rec-expresions-in-nixpkgs/8293/7 for more
      # discussion
      postPatch = prev.postPatch or "" + ''
        # set revision for --version output
        echo "COMMIT_HASH = '${final.src.rev}'" > inputremapper/commit_hash.py
      '';
    }
  )
