{ lib
, stdenv
, autoreconfHook
, bash
, bzip2
, corosync
, dbus
, fetchFromGitHub
, glib
, gnutls
, libqb
, libtool
, libuuid
, libxml2
, libxslt
, pam
, pkg-config
, python3

# Pacemaker is compiled twice, once with forOCF = true to extract its
# OCF definitions for use in the ocf-resource-agents derivation, then
# again with forOCF = false, where the ocf-resource-agents is provided
# as the OCF_ROOT.
, forOCF ? false
, ocf-resource-agents
} :

stdenv.mkDerivation rec {
  pname = "pacemaker";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "ClusterLabs";
    repo = pname;
    rev = "Pacemaker-${version}";
    sha256 = "1wrdqdxbdl506ry6i5zqwmf66ms96hx2h6rn4jzpi5w13wg8sbm4";
  };

  nativeBuildInputs = [
    autoreconfHook
    libtool
    pkg-config
  ];

  buildInputs = [
    bash
    bzip2
    corosync
    dbus.dev
    glib
    gnutls
    libqb
    libuuid
    libxml2.dev
    libxslt.dev
    pam
    python3
  ];

  configureFlags = [
    "--exec-prefix=${placeholder "out"}"
    "--sysconfdir=/etc"
    "--datadir=/var/lib"
    "--localstatedir=/var"
    "--enable-systemd"
    "--with-systemdsystemunitdir=/etc/systemd/system"
    "--with-corosync"
  ] ++ lib.optional (!forOCF) "--with-ocfdir=${ocf-resource-agents}/usr/lib/ocf";

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  NIX_CFLAGS_COMPILE = lib.optionals stdenv.cc.isGNU [
    "-Wno-error=strict-prototypes"
  ];

  postInstall = ''
    mv $out$out/* $out
    rm -r $out/nix
    ln -sf /var/lib/pacemaker/cib $out/var/lib/pacemaker/cib
  '';

  meta = with lib; {
    homepage = "https://clusterlabs.org/pacemaker/";
    description = "Pacemaker is an open source, high availability resource manager suitable for both small and large clusters.";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ryantm ];
  };
}
