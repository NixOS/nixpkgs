{ stdenv, buildPackages, fetchurl, which, autoconf, automake, flex
, yacc , glibc, perl, kerberos, libxslt, docbook_xsl
, docbook_xml_dtd_43 , libtool_2, removeReferencesTo
, ncurses # Extra ncurses utilities. Only needed for debugging.
, tsmbac ? null # Tivoli Storage Manager Backup Client from IBM
}:

with (import ./srcs.nix { inherit fetchurl; });

stdenv.mkDerivation {
  pname = "openafs";
  inherit version srcs;

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ autoconf automake flex libxslt libtool_2 perl
    removeReferencesTo which yacc ];

  buildInputs = [ kerberos ncurses ];

  patches = [ ./bosserver.patch ./cross-build.patch ] ++ stdenv.lib.optional (tsmbac != null) ./tsmbac.patch;

  outputs = [ "out" "dev" "man" "doc" "server" ];

  enableParallelBuilding = true;

  setOutputFlags = false;

  # Makefiles don't include install targets for all new shared libs, yet.
  dontDisableStatic = true;

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

    configureFlagsArray=(
      "--with-gssapi"
      "--sysconfdir=/etc"
      "--localstatedir=/var"
      "--disable-kernel-module"
      "--disable-fuse-client"
      "--with-html-xsl=${docbook_xsl}/share/xml/docbook-xsl/html/chunk.xsl"
      ${stdenv.lib.optionalString (tsmbac != null) "--enable-tivoli-tsm"}
      ${stdenv.lib.optionalString (ncurses == null) "--disable-gtx"}
      "--disable-linux-d_splice-alias-extra-iput"
      "--libexecdir=$server/libexec"
    )
  '' + stdenv.lib.optionalString (tsmbac != null) ''
    export XBSA_CFLAGS="-Dxbsa -DNEW_XBSA -I${tsmbac}/lib64/sample -DXBSA_TSMLIB=\\\"${tsmbac}/lib64/libApiTSM64.so\\\""
    export XBSA_XLIBS="-ldl"
  '';

  buildFlags = [ "all_nolibafs" ];

  postBuild = ''
    for d in doc/xml/{AdminGuide,QuickStartUnix,UserGuide}; do
      make -C "''${d}" index.html
    done
  '';

  postInstall = ''
    mkdir -p $doc/share/doc/openafs/{AdminGuide,QuickStartUnix,UserGuide}
    cp -r doc/{pdf,protocol,txt} README LICENSE $doc/share/doc/openafs
    for d in AdminGuide QuickStartUnix UserGuide ; do
      cp "doc/xml/''${d}"/*.html "$doc/share/doc/openafs/''${d}"
    done

    rm -r $out/lib/openafs
  '';

  # Avoid references to $TMPDIR by removing it and let patchelf cleanup the
  # binaries.
  preFixup = ''
    rm -rf "$(pwd)" && mkdir "$(pwd)"

    find $out -type f -exec remove-references-to -t $server '{}' '+'
  '';

  meta = with stdenv.lib; {
    outputsToInstall = [ "out" "doc" "man" ];
    description = "Open AFS client";
    homepage = https://www.openafs.org;
    license = licenses.ipl10;
    platforms = platforms.linux;
    maintainers = [ maintainers.maggesi maintainers.spacefrogg ];
  };
}
