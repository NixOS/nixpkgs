{ lib
, stdenv
<<<<<<< HEAD
, fetchFromGitLab
, writeText
, meson
, pkg-config
, ninja
, docbook-xsl-nons
, gettext
, libxslt
, gtk3
, libdrm
, libevdev
, libpng
, libxkbcommon
, pango
, systemd
, xorg
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plymouth";
  version = "unstable-2023-06-17";

  outputs = [ "out" "dev" ];
=======
, fetchpatch
, fetchFromGitLab
, pkg-config
, autoreconfHook
, libxslt
, docbook-xsl-nons
, gettext
, gtk3
, systemd
, pango
, cairo
, libdrm
}:

stdenv.mkDerivation rec {
  pname = "plymouth";
  version = "unstable-2021-10-18";

  outputs = [
    "out"
    "dev"
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "plymouth";
    repo = "plymouth";
<<<<<<< HEAD
    rev = "b1d5aa9d2a6033bba52cf63643e5878f8a9b68a0";
    hash = "sha256-8DXcwt8CZTni5Ma+I63LzNejlIB0Cr1ATA7Nl3z9z6I=";
  };

  patches = [
    # do not create unnecessary symlink to non-existent header-image.png
    ./dont-create-broken-symlink.patch
    # add support for loading plugins from /run to assist NixOS module
    ./add-runtime-plugin-path.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    docbook-xsl-nons
    gettext
    libxslt
  ];

  buildInputs = [
    gtk3
    libdrm
    libevdev
    libpng
    libxkbcommon
    pango
    systemd
    xorg.xkeyboardconfig
  ];

  mesonFlags = let
    # https://gitlab.freedesktop.org/plymouth/plymouth/-/blob/a5eda165689864cc9a25ec14fd8c6da458598f42/meson.build#L47
    crossFile = writeText "cross-file.conf" ''
      [binaries]
      systemd-tty-ask-password-agent = '${lib.getBin systemd}/bin/systemd-tty-ask-password-agent'
    '';
  in [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "-Dlogo=/etc/plymouth/logo.png"
    "-Dbackground-color=0x000000"
    "-Dbackground-start-color-stop=0x000000"
    "-Dbackground-end-color-stop=0x000000"
    "-Drelease-file=/etc/os-release"
    "-Dudev=enabled"
    "-Drunstatedir=/run"
    "-Druntime-plugins=true"
    "--cross-file=${crossFile}"
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace "run_command(['scripts/generate-version.sh'], check: true).stdout().strip()" "'${finalAttrs.version}'"

    # prevent installing unused non-$out dirs to DESTDIR
    sed -i '/^install_emptydir/d' src/meson.build
  '';

  postInstall = ''
    # Move stuff from DESTDIR to proper location.
    cp -a "$DESTDIR/etc" "$out"
    rm -r "$DESTDIR/etc"
    for o in $(getAllOutputNames); do
        if [[ "$o" = "debug" ]]; then continue; fi
        cp -a "$DESTDIR/''${!o}" "$(dirname "''${!o}")"
        rm -r "$DESTDIR/''${!o}"
    done
    # Ensure the DESTDIR is removed.
    rmdir "$DESTDIR/${builtins.storeDir}" "$DESTDIR/${builtins.dirOf builtins.storeDir}" "$DESTDIR"
  '';

  # HACK: We want to install configuration files to $out/etc
  # but Plymouth should read them from /etc on a NixOS system.
  # With autotools, it was possible to override Make variables
  # at install time but Meson does not support this
  # so we need to convince it to install all files to a temporary
  # location using DESTDIR and then move it to proper one in postInstall.
  env.DESTDIR = "${placeholder "out"}/dest";

=======
    rev = "18363cd887dbfe7e82a2f4cc1a49ef9513919142";
    sha256 = "sha256-+AP4ALOFdYFt/8MDXjMaHptkogCwK1iXKuza1zfMaws=";
  };

  nativeBuildInputs = [
    autoreconfHook
    docbook-xsl-nons
    gettext
    libxslt
    pkg-config
  ];

  buildInputs = [
    cairo
    gtk3
    libdrm
    pango
    systemd
  ];

  postPatch = ''
    sed -i \
      -e "s#plymouthplugindir=.*#plymouthplugindir=/etc/plymouth/plugins/#" \
      -e "s#plymouththemedir=.*#plymouththemedir=/etc/plymouth/themes#" \
      -e "s#plymouthpolicydir=.*#plymouthpolicydir=/etc/plymouth/#" \
      -e "s#plymouthconfdir=.*#plymouthconfdir=/etc/plymouth/#" \
      configure.ac
  '';

  configurePlatforms = [ "host" ];

  configureFlags = [
    "--enable-documentation"
    "--enable-drm"
    "--enable-gtk"
    "--enable-pango"
    "--enable-systemd-integration"
    "--enable-tracing"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--with-background-color=0x000000"
    "--with-background-end-color-stop=0x000000"
    "--with-background-start-color-stop=0x000000"
    "--with-logo=/etc/plymouth/logo.png"
    "--with-release-file=/etc/os-release"
    "--with-runtimedir=/run"
    "--with-systemdunitdir=${placeholder "out"}/etc/systemd/system"
    "--without-rhgb-compat-link"
    "--without-system-root-install"
    "ac_cv_path_SYSTEMD_ASK_PASSWORD_AGENT=${lib.getBin systemd}/bin/systemd-tty-ask-password-agent"
  ];

  installFlags = [
    "localstatedir=\${TMPDIR}"
    "plymouthd_confdir=${placeholder "out"}/etc/plymouth"
    "plymouthd_defaultsdir=${placeholder "out"}/share/plymouth"
    "sysconfdir=${placeholder "out"}/etc"
  ];

  postInstall = ''
    # Makes a symlink to /usr/share/pixmaps/system-logo-white.png
    # We'll handle it in the nixos module.
    rm $out/share/plymouth/themes/spinfinity/header-image.png
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/Plymouth/";
    description = "Boot splash and boot logger";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ] ++ teams.gnome.members;
    platforms = platforms.linux;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
