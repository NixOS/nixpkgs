{ lib, stdenv, fetchurl, fetchpatch, xmlto, docbook_xml_dtd_412
, libxslt, docbook_xsl, autoconf, automake, gettext, libiconv, libtool
}:

stdenv.mkDerivation rec {
  pname = "opensp";
  version = "1.5.2";

  src = fetchurl {
    url = "mirror://sourceforge/openjade/OpenSP-${version}.tar.gz";
    sha256 = "1khpasr6l0a8nfz6kcf3s81vgdab8fm2dj291n5r2s53k228kx2p";
  };

  postPatch = ''
    sed -i s,/usr/share/sgml/docbook/xml-dtd-4.1.2/,${docbook_xml_dtd_412}/xml/dtd/docbook/, \
      docsrc/*.xml
  '';

  patches = [
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/app-text/opensp/files/opensp-1.5.2-c11-using.patch?id=688d9675782dfc162d4e6cff04c668f7516118d0";
      sha256 = "04q14s8qsad0bkjmj067dn831i0r6v7742rafdlnbfm5y249m2q6";
    })
  ];

  setupHook = ./setup-hook.sh;

  postFixup = ''
    # Remove random ids in the release notes
    sed -i -e 's/href="#idm.*"//g' $out/share/doc/OpenSP/releasenotes.html
    sed -i -e 's/name="idm.*"//g' $out/share/doc/OpenSP/releasenotes.html
    '';

  preConfigure = lib.optionalString stdenv.isCygwin ''
    autoreconf -fi
  '';

  strictDeps = true;

  nativeBuildInputs = [
    xmlto
    docbook_xml_dtd_412
    docbook_xsl
  ] ++ lib.optionals stdenv.isCygwin [ autoconf automake libtool ];

  doCheck = false; # fails

  meta = with lib; {
    description = "A suite of SGML/XML processing tools";
    license = licenses.mit;
    homepage = "http://openjade.sourceforge.net/";
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
