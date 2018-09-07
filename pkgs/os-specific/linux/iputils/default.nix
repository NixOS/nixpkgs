{ stdenv, fetchFromGitHub, fetchpatch
, libxslt, docbook_xsl, docbook_xml_dtd_44
, libcap, nettle, libidn2, openssl
}:

with stdenv.lib;

let
  time = "20180629";
  # ninfod probably could build on cross, but the Makefile doesn't pass --host
  # etc to the sub configure...
  withNinfod = stdenv.hostPlatform == stdenv.buildPlatform;
  sunAsIsLicense = {
    fullName = "AS-IS, SUN MICROSYSTEMS license";
    url = "https://github.com/iputils/iputils/blob/s${time}/rdisc.c";
  };
in stdenv.mkDerivation {
  name = "iputils-${time}";

  src = fetchFromGitHub {
    owner = "iputils";
    repo = "iputils";
    rev = "s${time}";
    sha256 = "19rpl48pjgmyqlm4h7sml5gy7yg4cxciadxcs24q1zj40c05jls0";
  };

  patches = [
    (fetchpatch {
      name = "dont-hardcode-the-location-of-xsltproc.patch";
      url = "https://github.com/iputils/iputils/commit/d0ff83e87ea9064d9215a18e93076b85f0f9e828.patch";
      sha256 = "05wrwf0bfmax69bsgzh3b40n7rvyzw097j8z5ix0xsg0kciygjvx";
    })
  ];

  prePatch = ''
    substituteInPlace doc/custom-man.xsl \
      --replace "http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl" "${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl"
    for xmlFile in doc/*.xml; do
      substituteInPlace $xmlFile \
        --replace "http://www.oasis-open.org/docbook/xml/4.4/docbookx.dtd" "${docbook_xml_dtd_44}/xml/dtd/docbook/docbookx.dtd"
    done
  '';

  # Disable idn usage w/musl: https://github.com/iputils/iputils/pull/111
  makeFlags = optional stdenv.hostPlatform.isMusl "USE_IDN=no";

  nativeBuildInputs = [ libxslt.bin ];
  buildInputs = [ libcap nettle ]
    ++ optional (!stdenv.hostPlatform.isMusl) libidn2
    ++ optional withNinfod openssl; # TODO: Build with nettle

  buildFlags = "man all" + optionalString withNinfod " ninfod";

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man8

    for tool in arping clockdiff ping rarpd rdisc tftpd tracepath traceroute6; do
      cp $tool $out/bin/
      cp doc/$tool.8 $out/share/man/man8/
    done

    # TODO: Requires kernel module pg3
    cp ipg $out/bin/
    cp doc/pg3.8 $out/share/man/man8/
  '' + optionalString withNinfod ''
    cp ninfod/ninfod $out/bin/
    cp doc/ninfod.8 $out/share/man/man8/
  '';

  meta = {
    homepage = https://github.com/iputils/iputils;
    description = "A set of small useful utilities for Linux networking";
    license = with licenses; [ gpl2Plus bsd3 sunAsIsLicense ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos lheckemann ];
  };
}
