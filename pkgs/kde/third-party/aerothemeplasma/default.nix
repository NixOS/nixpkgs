{
  lib,
  stdenv,
  fetchFromGitHub,
  attica,
  breeze-icons,
  cmake,
  extra-cmake-modules,
  kauth,
  kcmutils,
  kconfig,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kglobalaccel,
  kguiaddons,
  ki18n,
  kiconthemes,
  kio,
  kirigami,
  kirigami-addons,
  kitemmodels,
  knewstuff,
  knotifications,
  knotifyconfig,
  kpackage,
  krunner,
  kstatusnotifieritem,
  ksvg,
  kwidgetsaddons,
  kwin,
  kwindowsystem,
  kxmlgui,
  libksysguard,
  libplasma,
  pkg-config,
  plasma-activities,
  plasma-activities-stats,
  plasma-desktop,
  plasma-integration,
  plasma-nm,
  plasma-pa,
  plasma-wayland-protocols,
  plasma-workspace,
  plasma5support,
  qqc2-desktop-style,
  qt5compat,
  qtbase,
  qtdeclarative,
  qtmultimedia,
  qtstyleplugin-kvantum,
  qtsvg,
  qtvirtualkeyboard,
  qtwayland,
  sonnet,
  wayland,
  wrapQtAppsHook,
}:

stdenv.mkDerivation {
  __structuredAttrs = true;

  pname = "aerothemeplasma";
  version = "6.7.0-unstable-2026-08-22";

  srcs = [
    (fetchFromGitHub {
      owner = "aeroshell-desktop";
      repo = "aerothemeplasma";
      rev = "afaaa49dad2a9fc894e44e05caf2d5be75f85061";
      hash = "sha256-l4QaCvka8LzKnx8y4/BFbNZnPKd2LVzaTIIKe1qZpFY=";
      name = "aerothemeplasma";
    })
    # The plasmoids import aeroshell-workspace's QML modules, so package both sources
    (fetchFromGitHub {
      owner = "aeroshell-desktop";
      repo = "aeroshell-workspace";
      rev = "00a39ba08f3b9441b0883f1b82fc4e7e9e6a44b7";
      hash = "sha256-UGT+MaFwSgLzacdwZTLhaxW5qhaSVa6ZFE6F4XCaHbE=";
      name = "aeroshell-workspace";
    })
  ];
  sourceRoot = "aerothemeplasma";

  # NixOS owns /usr/share/icons/default, so disable the helper that writes there
  patches = [ ./disable-system-cursor-helper.patch ];

  postPatch = ''
    substituteInPlace plasma/sddm/login-sessions/startatp.cmake plasma/sddm/login-sessions/startatp-wayland.cmake \
      --replace-fail "/etc/xdg/aerothemeplasma" "$out/etc/xdg/aerothemeplasma"
    substituteInPlace plasma/sddm/login-sessions/startatp.cmake plasma/sddm/login-sessions/startatp-wayland.cmake \
      --replace-fail "kreadconfig6" "${lib.getExe' kconfig "kreadconfig6"}"
    substituteInPlace plasma/sddm/login-sessions/startatp.cmake \
      --replace-fail "startplasma-x11" "${lib.getBin plasma-workspace}/bin/startplasma-x11"
    substituteInPlace plasma/sddm/login-sessions/startatp-wayland.cmake \
      --replace-fail '@CMAKE_INSTALL_FULL_LIBEXECDIR@/plasma-dbus-run-session-if-needed' \
        "${plasma-workspace}/libexec/plasma-dbus-run-session-if-needed" \
      --replace-fail "\''${CMAKE_INSTALL_FULL_BINDIR}/startplasma-wayland" \
        "${lib.getBin plasma-workspace}/bin/startplasma-wayland"
    substituteInPlace misc/xdg/autostart/x-atpootb.desktop \
      --replace-fail "/usr/bin/atpootb" "$out/bin/atpootb-autostart"
    substituteInPlace plasma/atpootb/src/app.h \
      --replace-fail "/usr/share/aerothemeplasma" "$out/share/aerothemeplasma"
    substituteInPlace plasma/atpootb/src/app.cpp \
      --replace-fail '"plasma-apply-lookandfeel"' \
        '"${lib.getExe' plasma-workspace "plasma-apply-lookandfeel"}"' \
      --replace-fail '"plasma-apply-cursortheme"' \
        '"${lib.getExe' plasma-workspace "plasma-apply-cursortheme"}"' \
      --replace-fail '"kvantummanager"' \
        '"${lib.getExe' qtstyleplugin-kvantum "kvantummanager"}"'
    substituteInPlace plasma/atpootb/src/CMakeLists.txt \
      --replace-fail "\''${CMAKE_INSTALL_PREFIX}/share/dbus-1/interfaces/org.kde.kwin.Effects.xml" \
        "${kwin}/share/dbus-1/interfaces/org.kde.kwin.Effects.xml"
    substituteInPlace plasma/shells/io.gitgud.wackyideas.desktop/contents/views/DesktopEditMode.qml \
      --replace-fail "/usr/share/sddm/themes/sddm-theme-mod" "$out/share/sddm/themes/sddm-theme-mod"
    substituteInPlace misc/xdg/kscreenlockerrc \
      --replace-fail "/usr/share/sddm/themes/sddm-theme-mod/bgtexture.jpg" \
        "$out/share/sddm/themes/sddm-theme-mod/background"
    substituteInPlace misc/xdg/kcm-about-distrorc \
      --replace-fail "/usr/share/aerothemeplasma/branding/kcminfo.png" \
        "$out/share/aerothemeplasma/branding/kcminfo.png"
    sed -i \
      -e 's/^        PlasmaQuick$/        Plasma::PlasmaQuick/' \
      -e 's/^        Plasma$/        Plasma::Plasma/' \
      plasma/plasmoids/src/sevenstart_src/src/CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    attica
    kauth
    kcmutils
    kconfig
    kcoreaddons
    kcrash
    kdbusaddons
    kglobalaccel
    kguiaddons
    ki18n
    kiconthemes
    kio
    kirigami
    kirigami-addons
    kitemmodels
    knewstuff
    knotifications
    knotifyconfig
    kpackage
    krunner
    kstatusnotifieritem
    ksvg
    kwidgetsaddons
    kwin
    kwindowsystem
    kxmlgui
    libksysguard
    libplasma
    plasma-activities
    plasma-activities-stats
    plasma-desktop
    plasma-nm
    plasma-pa
    plasma-wayland-protocols
    plasma-workspace
    plasma5support
    qqc2-desktop-style
    qt5compat
    qtbase
    qtdeclarative
    qtmultimedia
    qtstyleplugin-kvantum
    qtsvg
    qtvirtualkeyboard
    qtwayland
    sonnet
    wayland
  ];

  doCheck = true;

  env.QT_QPA_PLATFORM = "offscreen";

  nativeCheckInputs = [
    breeze-icons
    plasma-integration
  ];

  preCheck = ''
    export HOME="$TMPDIR"
    export QT_PLUGIN_PATH="${plasma-integration}/${qtbase.qtPluginPrefix}''${QT_PLUGIN_PATH:+:$QT_PLUGIN_PATH}"
    export QT_QPA_PLATFORMTHEME=kde
    export QT_QPA_SYSTEM_ICON_THEME=breeze
    export XDG_DATA_DIRS="${breeze-icons}/share''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
  '';

  postInstall = ''
    # INSTALL_X11_COMPONENTS omits the main package, so add only its session files
    install -Dm755 ../plasma/sddm/login-sessions/startatp.cmake $out/bin/startatp
    mkdir -p $out/share/xsessions
    substitute ../plasma/sddm/login-sessions/aerothemeplasmax11.desktop.cmake \
      $out/share/xsessions/aerothemeplasmax11.desktop \
      --replace-fail "\''${CMAKE_INSTALL_FULL_BINDIR}" "$out/bin"

    # XDG autostart is shared by all sessions, so run setup only in AeroThemePlasma
    cat > $out/bin/atpootb-autostart <<EOF
    #!${stdenv.shell}
    [ "\$PLASMA_DEFAULT_SHELL" = "io.gitgud.wackyideas.desktop" ] || exit 0
    exec "$out/bin/atpootb" "\$@"
    EOF
    chmod +x $out/bin/atpootb-autostart

    cmake -S ../../aeroshell-workspace -B build-workspace \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=$out \
      -DKDE_INSTALL_SYSCONFDIR=$out/etc \
      -DKDE_INSTALL_QMLDIR=$out/${qtbase.qtQmlPrefix} \
      -DBUILD_TESTING=OFF
    cmake --build build-workspace -j$NIX_BUILD_CORES
    cmake --install build-workspace
  '';

  postFixup = ''
    wrapQtApp "$out/bin/startatp"
    wrapQtApp "$out/bin/startatp-wayland"
  '';

  passthru = {
    providedSessions = [
      "aerothemeplasma"
      "aerothemeplasmax11"
    ];
    shellId = "io.gitgud.wackyideas.desktop";
  };

  meta = {
    description = "An alternative shell for KDE Plasma that aims to replicate the look and feel of Windows 7";
    longDescription = ''
      This is a project which aims to recreate the look and feel of Windows 7
      as much as possible on KDE Plasma, whilst adapting the design to fit in
      with modern features provided by KDE Plasma and Linux.
    '';
    homepage = "https://gitgud.io/aeroshell/atp/aerothemeplasma";
    license = with lib.licenses; [
      agpl3Only
      bsd2
      bsd3
      gpl2Only
      gpl2Plus
      gpl3Only
      lgpl2Plus
      lgpl21Only
      lgpl21Plus
      lgpl3Only
      mit
    ];
    maintainers = with lib.maintainers; [ aaravrav ];
    platforms = lib.platforms.linux;
  };
}
