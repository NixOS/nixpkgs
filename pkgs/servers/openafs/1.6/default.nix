{ stdenv, fetchurl, which, autoconf, automake, flex, yacc
, glibc, perl, kerberos, libxslt, docbook_xsl, docbook_xml_dtd_43
, ncurses # Extra ncurses utilities. Only needed for debugging.
, tsmbac ? null # Tivoli Storage Manager Backup Client from IBM
}:

with (import ./srcs.nix { inherit fetchurl; });

stdenv.mkDerivation rec {
  name = "openafs-${version}";
  inherit version srcs;

  nativeBuildInputs = [ autoconf automake flex yacc perl which libxslt ];

  buildInputs = [ ncurses ];

  patches = stdenv.lib.optional (tsmbac != null) ./tsmbac.patch;

  outputs = [ "out" "dev" "man" "doc" ];

  preConfigure = ''

    patchShebangs .
    for i in `grep -l -R '/usr/\(include\|src\)' .`; do
      echo "Patch /usr/include and /usr/src in $i"
      substituteInPlace $i \
        --replace "/usr/include" "${glibc.dev}/include" \
        --replace "/usr/src" "$TMP"
    done

    for i in ./doc/xml/{AdminGuide,QuickStartUnix,UserGuide}/*.xml; do
      substituteInPlace "''${i}" --replace "http://www.oasis-open.org/docbook/xml/4.3/docbookx.dtd" \
        "${docbook_xml_dtd_43}/xml/dtd/docbook/docbookx.dtd"
    done

    ./regen.sh

    ${stdenv.lib.optionalString (kerberos != null)
      "export KRB5_CONFIG=${kerberos.dev}/bin/krb5-config"}

    export AFS_SYSKVERS=26

    configureFlagsArray=(
      ${stdenv.lib.optionalString (kerberos != null) "--with-krb5"}
      "--sysconfdir=/etc"
      "--localstatedir=/var"
      "--disable-kernel-module"
      "--disable-fuse-client"
      "--with-html-xsl=${docbook_xsl}/share/xml/docbook-xsl/html/chunk.xsl"
      ${stdenv.lib.optionalString (tsmbac != null) "--enable-tivoli-tsm"}
      ${stdenv.lib.optionalString (ncurses == null) "--disable-gtx"}
      "--disable-linux-d_splice-alias-extra-iput"
    )
  '' + stdenv.lib.optionalString (tsmbac != null) ''
    export XBSA_CFLAGS="-Dxbsa -DNEW_XBSA -I${tsmbac}/lib64/sample -DXBSA_TSMLIB=\\\"${tsmbac}/lib64/libApiTSM64.so\\\""
    export XBSA_XLIBS="-ldl"
  '';

  buildFlags = [ "all_nolibafs" ];

  postBuild = ''
    for d in doc/xml/{AdminGuide,QuickStartUnix,UserGuide}; do
      make -C "''${d}" html
    done
  '';

  postInstall = ''
    mkdir -p $doc/share/doc/openafs/{AdminGuide,QuickStartUnix,UserGuide}
    cp -r doc/{arch,examples,pdf,protocol,txt} README NEWS $doc/share/doc/openafs
    for d in AdminGuide QuickStartUnix UserGuide ; do
      cp "doc/xml/''${d}"/*.html "$doc/share/doc/openafs/''${d}"
    done

    rm -r $out/lib/{openafs,afs,*.a}
    rm $out/bin/kpasswd
    rm $out/sbin/{kas,kdb,ka-forwarder,kadb_check}
    rm $out/libexec/openafs/kaserver
    rm $man/share/man/man{1/kpasswd*,5/kaserver*,8/{ka*,kdb*}}
  '';

  meta = with stdenv.lib; {
    outputsToInstall = [ "out" "doc" "man" ];
    description = "Open AFS client";
    homepage = https://www.openafs.org;
    license = licenses.ipl10;
    platforms = platforms.linux;
    maintainers = [ maintainers.z77z maintainers.spacefrogg ];
  };
}
