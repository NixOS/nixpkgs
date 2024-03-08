{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
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
, libsodium
}:

stdenv.mkDerivation rec {
  version = "1.1.2";
  pname = "usbguard";

  src = fetchFromGitHub {
    owner = "USBGuard";
    repo = pname;
    rev = "usbguard-${version}";
    sha256 = "sha256-uwNoKczmVOMpkU4KcKTOtbcTHiYVGXjk/rVbqMl5pGk=";
    fetchSubmodules = true;
  };

  patches = [
    # Pull upstream fix for gcc-13:
    #   https://github.com/USBGuard/usbguard/pull/586
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/USBGuard/usbguard/commit/22b1e0897af977cc96af926c730ff948bd120bb5.patch";
      hash = "sha256-yw0ZHcn6naHcsfsqdBB/aTgCwvEHecew/6HDmjyY2ZA=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    installShellFiles
    asciidoc
    pkg-config
    libxslt # xsltproc
    libxml2 # xmllint
    docbook_xml_dtd_45
    docbook_xsl
    dbus-glib # gdbus-codegen
    protobuf # protoc
  ];

  buildInputs = [
    dbus-glib
    libcap_ng
    libqb
    libseccomp
    libsodium
    polkit
    protobuf
    audit
  ];

  configureFlags = [
    "--with-bundled-catch"
    "--with-bundled-pegtl"
    "--with-dbus"
    "--with-crypto-library=sodium"
    "--with-polkit"
  ];

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
