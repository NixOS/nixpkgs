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
  pname = "plymouth";
  version = "22.02.122";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "plymouth";
    repo = "plymouth";
    rev = version;
    sha256 = "sha256-0/2k1DtAnjnvF5LeHrbO6cHrFDyQ02AWUj1XgmOZ/wA=";
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

  meta = with lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/Plymouth/";
    description = "Boot splash and boot logger";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ] ++ teams.gnome.members;
    platforms = platforms.linux;
  };
}
