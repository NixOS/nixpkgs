{ stdenv, fetchurl, writeText, pkgconfig, autoconf, automake, kerberos,
  openldap, popt, sasl, curl, xmlrpc_c, ding-libs, p11-kit, gettext, nspr, nss,
  dirsrv, svrcore, libuuid, talloc, tevent, samba, libunistring, libverto,
  systemd, python2, bind, pyhbac, jre, rhino, lesscpy }:

let
  name = "freeipa-${version}";
  version = "4.4.3";
  ipa-client-install = ./ipa-client-install;
  pathsPy = ./paths.py;
  pythonPackages = python2.pkgs;

  pythonInputs = with pythonPackages; [
    six ldap dns netaddr netifaces gssapi nss pyasn1 pyhbac cffi lxml pki-core
    dbus-python cryptography memcached qrcode pyusb yubico
  ];
in
stdenv.mkDerivation rec {
  inherit name;
  inherit version;

  src = fetchurl {
    url = "http://freeipa.org/downloads/src/${name}.tar.gz";
    sha1 = "cf1e078a6c1b52b81891e67b9b6b2a6d3436e98d";
  };

  nativeBuildInputs = [
    pythonPackages.wrapPython jre rhino lesscpy automake autoconf gettext
  ];

  buildInputs = [
    kerberos openldap popt sasl curl xmlrpc_c pkgconfig ding-libs p11-kit
    python2 autoconf nspr nss dirsrv svrcore libuuid talloc tevent samba
    libunistring libverto systemd bind
  ] ++ pythonInputs;

  postPatch = ''
    export SUPPORTED_PLATFORM=nixos
    export IPA_VERSION_IS_GIT_SNAPSHOT=no

    for file in makeapi makeaci install/ui/util; do patchShebangs $file; done

    substituteInPlace ipaserver/plugins/pwpolicy.py \
      --replace klist ${kerberos}/bin/klist

    substituteInPlace ipapython/p11helper.py \
      --replace "ctypes.util.find_library('p11-kit')" \"${p11-kit}/lib/libp11-kit.so\"

    for file in daemons/ipa-slapi-plugins/*/Makefile.*; do
      substituteInPlace $file \
        --replace "-I/usr/include/dirsrv" '$(DIRSRV_CFLAGS)'
    done

    for file in install/ui/util/build.sh install/ui/util/uglifyjs/uglify; do
     substituteInPlace $file \
        --replace /usr/share/java/js.jar ${rhino}/share/java/js.jar
    done

    substituteInPlace install/ui/util/make-css.sh \
      --replace lesscpy ${lesscpy}/bin/lesscpy

    for file in Makefile ipapython/Makefile ipalib/Makefile; do
      substituteInPlace $file \
        --replace "setup.py install --root" "setup.py install --prefix"
    done

    substituteInPlace client/ipa-join.c \
      --replace /usr/sbin/ipa-getkeytab $out/bin/ipa-getkeytab

    cp -r ipaplatform/{fedora,nixos}
    substitute ${pathsPy} ipaplatform/nixos/paths.py \
      --subst-var out \
      --subst-var-by bind ${bind.dnsutils} \
      --subst-var-by curl ${curl} \
      --subst-var-by kerberos ${kerberos}
  '';

  PYTHON="${python2}/bin/python";

  configurePhase = ''
    for dir in asn1 client daemons install; do
      pushd $dir
      configurePhase
      popd
    done
    pushd ipatests/man
    autoreconf -i -f
    configurePhase
    popd
  '';

  preBuild = ''
    make version-update
    export SKIP_API_VERSION_CHECK=yes
  '';

  NIX_CFLAGS_COMPILE = "-I${dirsrv}/include/dirsrv";
  pythonPath = pythonInputs;
  prefix = "/";

  # Building and installing the server fails with silent Rhino errors, skipping
  # for now. Need a newer Rhino version.
  #buildFlags = [ "client" "server" ];

  buildFlags = [ "client" ];
  installFlags = [ "DESTDIR=$(out)" ];
  installTargets = "client-install";
  checkFlags = [ "VERBOSE=yes" ];
  checkTargets = [ "client-check" ];

  postInstall = ''
    cat ${ipa-client-install} > $out/sbin/ipa-client-install
  '';

  postFixup = ''
    wrapPythonPrograms
    rmdir -p --ignore-fail-on-non-empty \
      $out/etc/ipa $out/var/lib/ipa-client/sysrestore
  '';

  meta = with stdenv.lib; {
    description = "Identity, Policy and Audit system";
    longDescription = ''
      IPA is an integrated solution to provide centrally managed Identity (users,
      hosts, services), Authentication (SSO, 2FA), and Authorization
      (host access control, SELinux user roles, services). The solution provides
      features for further integration with Linux based clients (SUDO, automount)
      and integration with Active Directory based infrastructures (Trusts).
    '';
    homepage = https://www.freeipa.org/;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.e-user ];
    platforms = platforms.linux;
  };
}
