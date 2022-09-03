{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, openldap
, libkrb5
, libxslt
, autoreconfHook
, pkg-config
, cyrus_sasl
, util-linux
, xmlto
, docbook_xsl
, docbook_xml_dtd_43
}:

stdenv.mkDerivation rec {
  pname = "adcli";
  version = "0.9.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "realmd";
    repo = pname;
    rev = version;
    sha256 = "sha256-Zzt4qgLiJNuSrbtDWuxJEfGL7sWSbqN301q3qXZpn9c=";
  };

  # https://bugs.gentoo.org/820224
  # Without this it produces some weird missing symbol error in glibc
  patches = [
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/app-crypt/adcli/files/adcli-0.9.1-glibc-2.34-resolv.patch?id=01db544de893262e857685e11b33c2a74210181f";
      sha256 = "sha256-dZ6dkzxd+0XjY/X9/2IWMan3syvCDGFHiMbxFxMHGFA=";
    })
  ];

  postPatch = ''
    substituteInPlace tools/Makefile.am \
      --replace 'sbin_PROGRAMS' 'bin_PROGRAMS'

    substituteInPlace doc/Makefile.am \
        --replace 'http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl' \
                  '${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl'

    function patch_docbook(){
      substituteInPlace $1 \
        --replace "http://www.oasis-open.org/docbook/xml/4.3/docbookx.dtd" \
                  "${docbook_xml_dtd_43}/xml/dtd/docbook/docbookx.dtd"
    }
    patch_docbook doc/adcli.xml
    patch_docbook doc/adcli-devel.xml
    patch_docbook doc/adcli-docs.xml
  '';
  nativeBuildInputs = [ autoreconfHook pkg-config docbook_xsl ];

  buildInputs = [ openldap libkrb5 libxslt cyrus_sasl util-linux xmlto docbook_xsl ];

  configureFlags = [ "--disable-debug" ];

  meta = with lib; {
    homepage = "https://www.freedesktop.org/software/realmd/adcli/adcli.html";
    description = "A helper library and tools for Active Directory client operations.";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ SohamG ];
    platforms = platforms.linux;
  };
}
