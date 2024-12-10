{
  lib,
  stdenv,
  fetchFromGitLab,
  openldap,
  libkrb5,
  libxslt,
  autoreconfHook,
  pkg-config,
  cyrus_sasl,
  util-linux,
  xmlto,
  docbook_xsl,
  docbook_xml_dtd_43,
}:

stdenv.mkDerivation rec {
  pname = "adcli";
  version = "0.9.2";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "realmd";
    repo = pname;
    rev = version;
    sha256 = "sha256-dipNKlIdc1DpXLg/YJjUxZlNoMFy+rt8Y/+AfWFA4dE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    docbook_xsl
    util-linux
    xmlto
  ];

  buildInputs = [
    openldap
    libkrb5
    libxslt
    cyrus_sasl
  ];

  configureFlags = [ "--disable-debug" ];

  postPatch = ''
    substituteInPlace tools/Makefile.am \
      --replace 'sbin_PROGRAMS' 'bin_PROGRAMS'

    substituteInPlace doc/Makefile.am \
        --replace 'http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl' \
                  '${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl'

    function patch_docbook() {
      substituteInPlace $1 \
        --replace "http://www.oasis-open.org/docbook/xml/4.3/docbookx.dtd" \
                  "${docbook_xml_dtd_43}/xml/dtd/docbook/docbookx.dtd"
    }
    patch_docbook doc/adcli.xml
    patch_docbook doc/adcli-devel.xml
    patch_docbook doc/adcli-docs.xml
  '';

  meta = with lib; {
    homepage = "https://www.freedesktop.org/software/realmd/adcli/adcli.html";
    description = "A helper library and tools for Active Directory client operations.";
    mainProgram = "adcli";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [
      SohamG
      anthonyroussel
    ];
    platforms = platforms.linux;
  };
}
