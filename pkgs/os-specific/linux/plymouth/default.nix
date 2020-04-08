{ lib, stdenv, fetchurl, autoreconfHook, pkgconfig, libxslt, docbook_xsl
, gtk3, udev, systemd
}:

stdenv.mkDerivation rec {
  pname = "plymouth";
  version = "0.9.4";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/plymouth/releases/${pname}-${version}.tar.xz";
    sha256 = "0l8kg7b2vfxgz9gnrn0v2w4jvysj2cirp0nxads5sy05397pl6aa";
  };

  nativeBuildInputs = [
    pkgconfig autoreconfHook
    libxslt docbook_xsl
  ];

  buildInputs = [
    gtk3 udev systemd
  ];

  postPatch = ''
    sed -i \
      -e "s#\$(\$PKG_CONFIG --variable=systemdsystemunitdir systemd)#$out/etc/systemd/system#g" \
      -e "s#plymouthplugindir=.*#plymouthplugindir=/etc/plymouth/plugins/#" \
      -e "s#plymouththemedir=.*#plymouththemedir=/etc/plymouth/themes#" \
      -e "s#plymouthpolicydir=.*#plymouthpolicydir=/etc/plymouth/#" \
      configure.ac
  '';

  configurePlatforms = [ "host" ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-systemdunitdir=${placeholder "out"}/etc/systemd/system"

    "--with-logo=/etc/plymouth/logo.png"
    "--with-release-file=/etc/os-release"

    "--with-background-color=0x000000"
    "--with-background-start-color-stop=0x000000"
    "--with-background-end-color-stop=0x000000"

    "--without-rhgb-compat-link"
    "--without-system-root-install"

    "--enable-gtk"
    "--enable-pango"
    "--enable-tracing"
    "--enable-gdm-transition"
    "--enable-systemd-integration"
    "ac_cv_path_SYSTEMD_ASK_PASSWORD_AGENT=${lib.getBin systemd}/bin/systemd-tty-ask-password-agent"
  ];

  installFlags = [
    "plymouthd_confdir=$(out)/etc/plymouth"
    "plymouthd_defaultsdir=$(out)/share/plymouth"
  ];

  meta = with lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/Plymouth/";
    description = "Boot splash and boot logger";
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
