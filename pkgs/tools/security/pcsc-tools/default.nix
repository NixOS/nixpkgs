{
  stdenv,
  lib,
  fetchFromGitHub,
  autoconf-archive,
  autoreconfHook,
  gobject-introspection,
  makeWrapper,
  pkg-config,
  wrapGAppsHook3,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd,
  systemd,
  dbusSupport ? stdenv.isLinux,
  dbus,
  pcsclite,
  PCSC,
  wget,
  coreutils,
  perlPackages,
  testers,
  nix-update-script,

  # gui does not cross compile properly
  withGui ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
}:

assert systemdSupport -> dbusSupport;

stdenv.mkDerivation (finalAttrs: {
  pname = "pcsc-tools";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "LudovicRousseau";
    repo = "pcsc-tools";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-+cvgSNlSYSJ2Zr2iWk96AacyQ38ru9/RK8yeK3ceqCo=";
  };

  configureFlags = [
    "--datarootdir=${placeholder "out"}/share"
  ];

  buildInputs =
    lib.optionals dbusSupport [
      dbus
    ]
    ++ [
      perlPackages.perl
      pcsclite
    ]
    ++ lib.optional stdenv.isDarwin PCSC
    ++ lib.optional systemdSupport systemd;

  nativeBuildInputs =
    [
      autoconf-archive
      autoreconfHook
      makeWrapper
      pkg-config
    ]
    ++ lib.optionals withGui [
      gobject-introspection
      wrapGAppsHook3
    ];

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postInstall =
    ''
      wrapProgram $out/bin/scriptor \
        --set PERL5LIB "${
          with perlPackages;
          makePerlPath [
            ChipcardPCSC
            libintl-perl
          ]
        }"

    ''
    + lib.optionalString withGui ''
      wrapProgram $out/bin/gscriptor \
        ''${makeWrapperArgs[@]} \
        --set PERL5LIB "${
          with perlPackages;
          makePerlPath [
            ChipcardPCSC
            libintl-perl
            GlibObjectIntrospection
            Glib
            Gtk3
            Pango
            Cairo
            CairoGObject
          ]
        }"
    ''
    + ''

      wrapProgram $out/bin/ATR_analysis \
        --set PERL5LIB "${
          with perlPackages;
          makePerlPath [
            ChipcardPCSC
            libintl-perl
          ]
        }"

      wrapProgram $out/bin/pcsc_scan \
        --prefix PATH : "$out/bin:${
          lib.makeBinPath [
            coreutils
            wget
          ]
        }"

      install -Dm444 -t $out/share/pcsc smartcard_list.txt
    '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "pcsc_scan -V";
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Tools used to test a PC/SC driver, card or reader";
    homepage = "https://pcsc-tools.apdu.fr/";
    changelog = "https://github.com/LudovicRousseau/pcsc-tools/releases/tag/${finalAttrs.version}";
    license = licenses.gpl2Plus;
    mainProgram = "pcsc_scan";
    maintainers = with maintainers; [
      peterhoeg
      anthonyroussel
    ];
    platforms = platforms.unix;
  };
})
