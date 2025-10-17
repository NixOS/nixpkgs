{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
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
  versionCheckHook,
}:

let
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
    ifaddr
  ];
in
stdenv.mkDerivation rec {
  pname = "freeipa";
  version = "4.12.5";

  src = fetchurl {
    url = "https://releases.pagure.org/freeipa/freeipa-${version}.tar.gz";
    hash = "sha256-jvXS9Hx9VGFccFL19HogfH15JVIW7pc3/TY1pOvJglM=";
  };

  patches = [
    (fetchpatch {
      name = "support-pyca-44.0";
      url = "https://github.com/freeipa/freeipa/pull/7619/commits/2dc4133920fe58ce414c545102c74173d40d1997.patch";
      hash = "sha256-PROnPc/1qS3hcO8s5sel55tsyZ1VPjEKLcua8Pd4DP0=";
    })
    (fetchpatch {
      name = "fix-tripledes-cipher-warnings";
      url = "https://github.com/freeipa/freeipa/pull/7619/commits/e2bf6e4091c7b5320ec6387dab2d5cabe4a9a42d.patch";
      hash = "sha256-AyMK0hjXMrFK4/qIcjPMFH9DKvnvYOK2QS83Otcc+l4=";
    })
  ];

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
  ]
  ++ pythonInputs;

  postPatch = ''
    patchShebangs makeapi makeaci install/ui/util

    substituteInPlace ipasetup.py.in \
      --replace 'int(v)' 'int(v.replace("post", ""))'

    substituteInPlace client/ipa-join.c \
      --replace /usr/sbin/ipa-getkeytab $out/bin/ipa-getkeytab

    substituteInPlace ipaplatform/nixos/paths.py \
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

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

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
    maintainers = with maintainers; [
      s1341
      benley
    ];
    platforms = platforms.linux;
    mainProgram = "ipa";
  };
}
