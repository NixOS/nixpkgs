{ lib, stdenv, fetchurl, python, pkgconfig, perl, libxslt, docbook_xsl
, fetchpatch
, docbook_xml_dtd_42, readline, talloc
, popt, iniparser, libbsd, libarchive, libiconv, gettext
, krb5Full, zlib, openldap, cups, pam, avahi, acl, libaio, fam, libceph, glusterfs
, gnutls, ncurses, libunwind, systemd

, enableLDAP ? false
, enablePrinting ? false
, enableMDNS ? false
, enableDomainController ? false
, enableRegedit ? true
, enableCephFS ? false
, enableGlusterFS ? false
, enableAcl ? (!stdenv.isDarwin)
, enablePam ? (!stdenv.isDarwin)
}:

with lib;

stdenv.mkDerivation rec {
  name = "samba-${version}";
  version = "4.7.12";

  src = fetchurl {
    url = "mirror://samba/pub/samba/stable/${name}.tar.gz";
    sha256 = "0jmg39xigrh48j39r4f1390kmr1p3xbfxzfabln4b0r9qdmki70f";
  };

  outputs = [ "out" "dev" "man" ];

  patches =
    [ ./4.x-no-persistent-install.patch
      ./patch-source3__libads__kerberos_keytab.c.patch
      ./4.x-no-persistent-install-dynconfig.patch
      (fetchpatch {
        url = "https://patch-diff.githubusercontent.com/raw/samba-team/samba/pull/107.patch";
        sha256 = "0r6q34vjj0bdzmcbnrkad9rww58k4krbwicv4gs1g3dj49skpvd6";
      })
      # note the following is a patch against the 4.8 branch, but luckily it applies
      # and works against 4.7
      (fetchpatch {
        name = "4.8-CVE-2019-3880.patch";
        url = "https://gitlab.com/samba-team/samba/commit/9a3ee861e43f84d48ef47998ceeb3bbf29f0c948.patch";
        sha256 = "12822dpdar7jp65r86ppd2f0az414azzvaslb04ngbcz62zwskfw";
      })
      # and the following are all patches against the 4.9 branch, but luckily they all apply
      # and work against 4.7 too
      (fetchpatch {
        name = "4.9-CVE-2019-10218.part1.patch";
        url = "https://gitlab.com/samba-team/samba/commit/fc6022b9b19473076c4236fdf4ac474f44ca73e2.patch";
        sha256 = "1y6cax6rhrwqnqhyh764sdc19vask3v3abrk7vnvyb24rc52q4v9";
      })
      (fetchpatch {
        name = "4.9-CVE-2019-10218.part2.patch";
        url = "https://gitlab.com/samba-team/samba/commit/167f78aa97af6502cb2027dc9dad40399b0a9c4f.patch";
        sha256 = "1ncib6j4nrybzdq1bg02va7yh98s2faplfngwg3d0mkd4l1lr1wc";
      })
      (fetchpatch {
        name = "4.9-CVE-2019-14833.part1.patch";
        url = "https://gitlab.com/samba-team/samba/commit/e6de467a763b93152eef27726957a32879268fb7.patch";
        sha256 = "13s6n4kb9m8vp1cn3kvldnqdirxmk3lm0klr0kjd81n762gmc0r3";
      })
      (fetchpatch {
        name = "4.9-CVE-2019-14833.part2.patch";
        url = "https://gitlab.com/samba-team/samba/commit/70078d4ddf3b842eeadee058dadeef82ec4edf0b.patch";
        sha256 = "0z80x6qycip28lp0x0xdbj0a0f2s1cjzl1ry4ds3wr4hi9v9dqps";
      })
      (fetchpatch {
        name = "4.9-CVE-2019-14847.part1.patch";
        url = "https://gitlab.com/samba-team/samba/commit/ea39bdd6293041af668f1bfdfea39a725733bad3.patch";
        sha256 = "1rrdz6a649is3mqx3syzlq769f08yavr2hjnd626hkxxxbvhsysc";
      })
      (fetchpatch {
        name = "4.9-CVE-2019-14847.part2.patch";
        url = "https://gitlab.com/samba-team/samba/commit/bdb3e3f669bd991da819040e726e003e4e2b841d.patch";
        sha256 = "12mjby9vzp29s93q2wk73kalpr345gx813lhmvgkalbn6186w5f7";
      })
      (fetchpatch {
        name = "4.9-CVE-2019-14847.part3.patch";
        url = "https://gitlab.com/samba-team/samba/commit/77b10b360f4ffb7ac90bc5fce0a80306515c1aca.patch";
        sha256 = "0mclx3zdb2l8w4p1iyak6d82dpnyksp3ixj5syck6v0f10nkniz8";
      })
    ];

  buildInputs =
    [ python pkgconfig perl libxslt docbook_xsl docbook_xml_dtd_42 /*
      docbook_xml_dtd_45 */ readline talloc popt iniparser
      libbsd libarchive zlib fam libiconv gettext libunwind krb5Full
    ]
    ++ optionals stdenv.isLinux [ libaio systemd ]
    ++ optional enableLDAP openldap
    ++ optional (enablePrinting && stdenv.isLinux) cups
    ++ optional enableMDNS avahi
    ++ optional enableDomainController gnutls
    ++ optional enableRegedit ncurses
    ++ optional (enableCephFS && stdenv.isLinux) libceph
    ++ optional (enableGlusterFS && stdenv.isLinux) glusterfs
    ++ optional enableAcl acl
    ++ optional enablePam pam;

  postPatch = ''
    # Removes absolute paths in scripts
    sed -i 's,/sbin/,,g' ctdb/config/functions

    # Fix the XML Catalog Paths
    sed -i "s,\(XML_CATALOG_FILES=\"\),\1$XML_CATALOG_FILES ,g" buildtools/wafsamba/wafsamba.py
  '';

  configureFlags =
    [ "--with-static-modules=NONE"
      "--with-shared-modules=ALL"
      "--with-system-mitkrb5"
      "--with-system-mitkdc" "${krb5Full}"
      "--enable-fhs"
      "--sysconfdir=/etc"
      "--localstatedir=/var"
    ]
    ++ [(if enableDomainController
         then "--with-experimental-mit-ad-dc"
         else "--without-ad-dc")]
    ++ optionals (!enableLDAP) [ "--without-ldap" "--without-ads" ]
    ++ optional (!enableAcl) "--without-acl-support"
    ++ optional (!enablePam) "--without-pam";

  # To build in parallel.
  buildPhase = "python buildtools/bin/waf build -j $NIX_BUILD_CORES";

  # Some libraries don't have /lib/samba in RPATH but need it.
  # Use find -type f -executable -exec echo {} \; -exec sh -c 'ldd {} | grep "not found"' \;
  # Looks like a bug in installer scripts.
  postFixup = ''
    export SAMBA_LIBS="$(find $out -type f -name \*.so -exec dirname {} \; | sort | uniq)"
    read -r -d "" SCRIPT << EOF || true
    [ -z "\$SAMBA_LIBS" ] && exit 1;
    BIN='{}';
    OLD_LIBS="\$(patchelf --print-rpath "\$BIN" 2>/dev/null | tr ':' '\n')";
    ALL_LIBS="\$(echo -e "\$SAMBA_LIBS\n\$OLD_LIBS" | sort | uniq | tr '\n' ':')";
    patchelf --set-rpath "\$ALL_LIBS" "\$BIN" 2>/dev/null || exit $?;
    patchelf --shrink-rpath "\$BIN";
    EOF
    find $out -type f -name \*.so -exec $SHELL -c "$SCRIPT" \;
  '';

  meta = with stdenv.lib; {
    homepage = https://www.samba.org/;
    description = "The standard Windows interoperability suite of programs for Linux and Unix";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
