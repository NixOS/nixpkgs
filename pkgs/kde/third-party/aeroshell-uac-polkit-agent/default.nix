{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  extra-cmake-modules,
  kconfig,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  ki18n,
  kirigami,
  kirigami-addons,
  knotifications,
  ksvg,
  kwindowsystem,
  nix-update-script,
  polkit-kde-agent-1,
  polkit-qt-1,
  qtbase,
  qtdeclarative,
  qtmultimedia,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aeroshell-uac-polkit-agent";
  version = "6.7.0-unstable-2026-06-20";

  __structuredAttrs = true;

  src = fetchFromGitLab {
    domain = "gitgud.io";
    owner = "aeroshell";
    repo = "uac-polkit-agent";
    rev = "d8c2262f5a12fe1a53560e70414b9312b91d84bb";
    hash = "sha256-SltZEKT8CvCWirx00b3ZjCWv8Smc/AEppTuXhXVKQts=";
  };

  postPatch = ''
    substituteInPlace uac-polkit-agent.conf.in \
      --replace-fail "@KDE_INSTALL_FULL_LIBEXECDIR@/polkit-kde-authentication-agent-1" \
        "${polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    kconfig
    kcoreaddons
    kcrash
    kdbusaddons
    ki18n
    kirigami
    kirigami-addons
    knotifications
    ksvg
    kwindowsystem
    polkit-qt-1
    qtbase
    qtdeclarative
    qtmultimedia
  ];

  postInstall = ''
    mkdir -p $out/share/systemd/user
    mv $out/etc/systemd/user/plasma-polkit-agent.service.d $out/share/systemd/user/
    rmdir $out/etc/systemd/user $out/etc/systemd
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch=Plasma/${lib.versions.majorMinor finalAttrs.version}" ];
  };

  meta = {
    description = "UAC Polkit Agent is an alternative frontend designed to look like the User Account Control dialog on Windows Vista and 7";
    homepage = "https://gitgud.io/aeroshell/uac-polkit-agent";
    license = with lib.licenses; [
      cc0
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [ aaravrav ];
    platforms = lib.platforms.linux;
  };
})
