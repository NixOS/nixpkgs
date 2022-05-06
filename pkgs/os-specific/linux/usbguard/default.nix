{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, installShellFiles
, nixosTests
, asciidoc
, pkg-config
, libxslt
, libxml2
, docbook_xml_dtd_45
, docbook_xsl
, dbus-glib
, libcap_ng
, libqb
, libseccomp
, polkit
, protobuf
, audit
, libgcrypt
, libsodium
}:

assert libgcrypt != null -> libsodium == null;

stdenv.mkDerivation rec {
  version = "1.1.1";
  pname = "usbguard";

  src = fetchFromGitHub {
    owner = "USBGuard";
    repo = pname;
    rev = "usbguard-${version}";
    sha256 = "sha256-lAh+l9GF+FHQqv2kEYU5JienZKGwR5e45BYAwjieYgw=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    autoreconfHook
    installShellFiles
    asciidoc
    pkg-config
    libxslt # xsltproc
    libxml2 # xmllint
    docbook_xml_dtd_45
    docbook_xsl
  ];

  buildInputs = [
    dbus-glib
    libcap_ng
    libqb
    libseccomp
    polkit
    protobuf
    audit
  ]
  ++ (lib.optional (libgcrypt != null) libgcrypt)
  ++ (lib.optional (libsodium != null) libsodium);

  configureFlags = [
    "--with-bundled-catch"
    "--with-bundled-pegtl"
    "--with-dbus"
    "--with-polkit"
  ]
  ++ (lib.optional (libgcrypt != null) "--with-crypto-library=gcrypt")
  ++ (lib.optional (libsodium != null) "--with-crypto-library=sodium");

  enableParallelBuilding = true;

  postInstall = ''
    installShellCompletion --bash --name usbguard.bash scripts/bash_completion/usbguard
    installShellCompletion --zsh --name _usbguard scripts/usbguard-zsh-completion
  '';

  passthru.tests = nixosTests.usbguard;

  meta = with lib; {
    description = "The USBGuard software framework helps to protect your computer against BadUSB";
    longDescription = ''
      USBGuard is a software framework for implementing USB device authorization
      policies (what kind of USB devices are authorized) as well as method of
      use policies (how a USB device may interact with the system). Simply put,
      it is a USB device whitelisting tool.
    '';
    homepage = "https://usbguard.github.io/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.tnias ];
  };
}
