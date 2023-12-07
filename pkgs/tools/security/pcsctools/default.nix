{ stdenv
, lib
, fetchFromGitHub
, autoconf-archive
, autoreconfHook
, gobject-introspection
, makeWrapper
, pkg-config
, wrapGAppsHook
, systemd
, dbus
, pcsclite
, wget
, coreutils
, perlPackages
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "pcsc-tools";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "LudovicRousseau";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-tTeSlS1ncpdIaoJsSVgm3zSCogP6S8zlA9hRFocZ/R4=";
  };

  configureFlags = [
    "--datarootdir=${placeholder "out"}/share"
  ];

  buildInputs = [ dbus perlPackages.perl pcsclite ]
    ++ lib.optional stdenv.isLinux systemd;

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    gobject-introspection
    makeWrapper
    pkg-config
    wrapGAppsHook
  ];

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postInstall = ''
    wrapProgram $out/bin/scriptor \
      --set PERL5LIB "${with perlPackages; makePerlPath [ ChipcardPCSC ]}"

    wrapProgram $out/bin/gscriptor \
      ''${makeWrapperArgs[@]} \
      --set PERL5LIB "${with perlPackages; makePerlPath [
          ChipcardPCSC
          libintl-perl
          GlibObjectIntrospection
          Glib
          Gtk3
          Pango
          Cairo
          CairoGObject
      ]}"

    wrapProgram $out/bin/ATR_analysis \
      --set PERL5LIB "${with perlPackages; makePerlPath [ ChipcardPCSC libintl-perl ]}"

    wrapProgram $out/bin/pcsc_scan \
      --prefix PATH : "$out/bin:${lib.makeBinPath [ coreutils wget ]}"

    install -Dm444 -t $out/share/pcsc smartcard_list.txt
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Tools used to test a PC/SC driver, card or reader";
    homepage = "https://pcsc-tools.apdu.fr/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
  };
}
