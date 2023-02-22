{ lib
, stdenv
, fetchFromGitLab
, meson
, pkg-config
, libpng
, udev
, pango
, gtk3
, libdrm
, libevdev
, libxkbcommon
, xorg
, libxslt
, ninja
, docbook-xsl-nons
, systemd
}:

stdenv.mkDerivation rec {
  pname = "plymouth";
  version = "unstable-2023-02-22";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = pname;
    repo = pname;
    rev = "7302b49da8b98d01ab82d23e5be74146065cffd8";
    hash = "sha256-PgVJezSUd/E3o1YigVto5KmQlflONrmKspOmAHSc5p4=";
  };

  patches = [
    ./add-option-for-installation-sysconfdir.patch
    ./dont-create-broken-symlink.patch
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    docbook-xsl-nons
  ];

  buildInputs = [
    libpng
    udev
    pango
    gtk3
    libdrm
    libevdev
    libxkbcommon
    xorg.xkeyboardconfig
    libxslt
    systemd
  ];

  mesonFlags = [
    "--sysconfdir=/etc"
    "-Dlogo=/etc/plymouth/logo.png"
    "-Dbackground-color=0x000000"
    "-Dbackground-start-color-stop=0x000000"
    "-Dbackground-end-color-stop=0x000000"
    "-Drelease-file=/etc/os-release"
    "-Dtracing=true"
    "-Dsystemd-integration=true"
    "-Dudev=enabled"
    "-Dpango=enabled"
    "-Dfreetype=enabled"
    "-Dgtk=enabled"
    "-Ddrm=true"
    "-Ddocs=true"
    "-Drunstatedir=/run"
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace "run_command(['scripts/generate-version.sh'], check: true).stdout().strip()" "'${version}'"

    sed -i '/^install_emptydir/d' src/meson.build
  '';

  postInstall = ''
    ln -s "/etc/plymouth/logo.png" "$out/etc/plymouth/logo.png"
    # Logo for spinfinity theme
    # See: https://gitlab.freedesktop.org/plymouth/plymouth/-/issues/106
    ln -s "/etc/plymouth/logo.png" "$out/share/plymouth/themes/spinfinity/header-image.png"
    # Logo for bgrt theme
    # Note this is technically an abuse of watermark for the bgrt theme
    # See: https://gitlab.freedesktop.org/plymouth/plymouth/-/issues/95#note_813768
    ln -s "/etc/plymouth/logo.png" "$out/share/plymouth/themes/spinner/watermark.png"
  '';

  meta = with lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/Plymouth/";
    description = "Boot splash and boot logger";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ] ++ teams.gnome.members;
    platforms = platforms.linux;
  };
}
