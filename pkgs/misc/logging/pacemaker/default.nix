{ lib
, stdenv
, autoconf
, automake
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
, nixosTests

# Pacemaker is compiled twice, once with forOCF = true to extract its
# OCF definitions for use in the ocf-resource-agents derivation, then
# again with forOCF = false, where the ocf-resource-agents is provided
# as the OCF_ROOT.
, forOCF ? false
, ocf-resource-agents
} :

stdenv.mkDerivation rec {
  pname = "pacemaker";
  version = "2.1.8";

  src = fetchFromGitHub {
    owner = "ClusterLabs";
    repo = pname;
    rev = "Pacemaker-${version}";
    sha256 = "sha256-J57+NSs4cL3BlEjSaXAoUTEhbMMxhWy8sUZ/K3x2nRM=";
  };

  nativeBuildInputs = [
    autoconf
    automake
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

  preConfigure = ''
    ./autogen.sh --prefix="$out"
  '';
  configureFlags = [
    "--exec-prefix=${placeholder "out"}"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-initdir=/etc/systemd/system"
    "--with-systemdsystemunitdir=/etc/systemd/system"
    "--with-corosync"
    # allows Type=notify in the systemd service
    "--enable-systemd"
  ] ++ lib.optional (!forOCF) "--with-ocfdir=${ocf-resource-agents}/usr/lib/ocf";

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.cc.isGNU [
    "-Wno-error=strict-prototypes"
    "-Wno-error=deprecated-declarations"
  ]);

  enableParallelBuilding = true;

  postInstall = ''
    # pacemaker's install linking requires a weirdly nested hierarchy
    mv $out$out/* $out
    rm -r $out/nix
  '';

  passthru.tests = {
    inherit (nixosTests) pacemaker;
  };

  meta = with lib; {
    homepage = "https://clusterlabs.org/pacemaker/";
    description = "Pacemaker is an open source, high availability resource manager suitable for both small and large clusters";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ryantm astro ];
  };
}
