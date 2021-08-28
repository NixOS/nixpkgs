{ lib
, stdenv
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
  pname = "plymouth-unstable";
  version = "2020-12-07";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "plymouth";
    repo = "plymouth";
    rev = "c4ced2a2d70edea7fbb95274aa1d01d95928df1b";
    sha256 = "7CPuKMA0fTt8DBsaA4Td74kHT/O7PW8N3awP04nUnOI=";
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

  patches = [
    # KillMode=none is deprecated
    # https://gitlab.freedesktop.org/plymouth/plymouth/-/issues/123
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/plymouth/plymouth/-/commit/b406b0895a95949db2adfedaeda451f36f2b51c3.patch";
      sha256 = "/UBImNuFO0G/oxlttjGIXon8YXMXlc9XU8uVuR9QuxY=";
    })
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

  meta = with lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/Plymouth/";
    description = "Boot splash and boot logger";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu teams.gnome.members ];
    platforms = platforms.linux;
  };
}
