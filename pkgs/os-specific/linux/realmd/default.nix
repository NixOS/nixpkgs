{ lib, stdenv
, autoreconfHook
, docbook_xml_dtd_412
, docbook_xml_dtd_42
, docbook_xml_dtd_43
, docbook_xsl
, fetchFromGitLab
, glib
, intltool
, libkrb5
, libtool
, libxslt
, openldap
, pkg-config
, polkit
, systemd
, xmlto
}:
# doc-related (--disable-doc): docbook_xml_dtd_412 docbook_xml_dtd_42 docbook_xml_dtd_43 docbook_xsl libxslt xmlto

stdenv.mkDerivation rec {
  pname = "realmd";
  version = "0.17.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1c6q2a86kk2f1akzc36nh52hfwsmmc0mbp6ayyjxj4zsyk9zx5bf";
  };

  # service/Makefile.am expects to find the file "service/realmd-NixOS.conf", which:
  # - isn't provided by upstream
  # - doesn't make sense in this context and should rather be provided by a module configuring the realmd service
  # don't install "/var/cache" and "/var/lib" which should be provided by the service unit at runtime
  patches = [ ./remove-distro-and-fhs.patch ];

  configureFlags = [
    "--with-distro=NixOS"
    "--with-systemd-unit-dir=${placeholder "out"}/lib/systemd/system"
  ];

  nativeBuildInputs = [
    autoreconfHook
    docbook_xml_dtd_412
    docbook_xml_dtd_42
    docbook_xml_dtd_43
    docbook_xsl
  ];

  buildInputs = [
    glib
    intltool
    libkrb5
    libxslt
    openldap
    pkg-config
    polkit
    systemd
    xmlto
  ];

  meta = with lib; {
    homepage = "https://gitlab.freedesktop.org/realmd/realmd";
    description = "Service + helpers for configuring Kerberos, AD-membership and other online identities";
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ eliasp ];
  };
}
