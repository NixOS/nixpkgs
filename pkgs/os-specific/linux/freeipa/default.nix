{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  autoconf,
  automake,
  kerberos,
  openldap,
  popt,
  sasl,
  curl,
  xmlrpc_c,
  ding-libs,
  p11-kit,
  gettext,
  nspr,
  nss,
  _389-ds-base,
  svrcore,
  libuuid,
  talloc,
  tevent,
  samba,
  libunistring,
  libverto,
  libpwquality,
  systemd,
  python3,
  bind,
  sssd,
  jre,
  rhino,
  lesscpy,
  jansson,
  runtimeShell,
}:

let
  pathsPy = ./paths.py;

  pythonInputs = with python3.pkgs; [
    distutils
    six
    python-ldap
    dnspython
    netaddr
    netifaces
    gssapi
    dogtag-pki
    pyasn1
    sssd
    cffi
    lxml
    dbus-python
    cryptography
    python-memcached
    qrcode
    pyusb
    yubico
    setuptools
    jinja2
    augeas
    samba
  ];
in
stdenv.mkDerivation rec {
  pname = "freeipa";
  version = "4.12.1";

  src = fetchurl {
    url = "https://releases.pagure.org/freeipa/freeipa-${version}.tar.gz";
    sha256 = "sha256-SPZ+QgssDKG1Hz1oqtVdg864qtcvncuOlzTWjN4+loM=";
  };

  nativeBuildInputs = [
    python3.pkgs.wrapPython
    jre
    rhino
    lesscpy
    automake
    autoconf
    gettext
    pkg-config
  ];

  buildInputs = [
    kerberos
    openldap
    popt
    sasl
    curl
    xmlrpc_c
    ding-libs
    p11-kit
    python3
    nspr
    nss
    _389-ds-base
    svrcore
    libuuid
    talloc
    tevent
    samba
    libunistring
    libverto
    systemd
    bind
    libpwquality
    jansson
  ] ++ pythonInputs;

  postPatch = ''
    patchShebangs makeapi makeaci install/ui/util

    substituteInPlace ipaplatform/setup.py \
      --replace 'ipaplatform.debian' 'ipaplatform.nixos'

    substituteInPlace ipasetup.py.in \
      --replace 'int(v)' 'int(v.replace("post", ""))'

    substituteInPlace client/ipa-join.c \
      --replace /usr/sbin/ipa-getkeytab $out/bin/ipa-getkeytab

    cp -r ipaplatform/{fedora,nixos}
    substitute ${pathsPy} ipaplatform/nixos/paths.py \
      --subst-var out \
      --subst-var-by bind ${bind.dnsutils} \
      --subst-var-by curl ${curl} \
      --subst-var-by kerberos ${kerberos}
  '';

  NIX_CFLAGS_COMPILE = "-I${_389-ds-base}/include/dirsrv";
  pythonPath = pythonInputs;

  # Building and installing the server fails with silent Rhino errors, skipping
  # for now. Need a newer Rhino version.
  #buildFlags = [ "client" "server" ]

  configureFlags = [
    "--with-systemdsystemunitdir=$out/lib/systemd/system"
    "--with-ipaplatform=nixos"
    "--disable-server"
  ];

  postInstall = ''
    echo "
     #!${runtimeShell}
     echo 'ipa-client-install is not available on NixOS. Please see security.ipa, instead.'
     exit 1
    " > $out/sbin/ipa-client-install
  '';

  postFixup = ''
    wrapPythonPrograms
    rm -rf $out/etc/ipa $out/var/lib/ipa-client/sysrestore
  '';

  meta = with lib; {
    description = "Identity, Policy and Audit system";
    longDescription = ''
      IPA is an integrated solution to provide centrally managed Identity (users,
      hosts, services), Authentication (SSO, 2FA), and Authorization
      (host access control, SELinux user roles, services). The solution provides
      features for further integration with Linux based clients (SUDO, automount)
      and integration with Active Directory based infrastructures (Trusts).
    '';
    homepage = "https://www.freeipa.org/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.s1341 ];
    platforms = platforms.linux;
    mainProgram = "ipa";
  };
}
