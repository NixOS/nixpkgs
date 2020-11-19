{ stdenv, buildPackages, fetchurl, which, autoconf, automake, flex
, yacc , glibc, perl, kerberos, libxslt, docbook_xsl, file
, docbook_xml_dtd_43, libtool_2
, withDevdoc ? false, doxygen, dblatex # Extra developer documentation
, ncurses # Extra ncurses utilities. Needed for debugging and monitoring.
, tsmbac ? null # Tivoli Storage Manager Backup Client from IBM
}:

with (import ./srcs.nix { inherit fetchurl; });
let
  inherit (stdenv.lib) optional optionalString optionals;

in stdenv.mkDerivation {
  pname = "openafs";
  inherit version srcs;

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ autoconf automake flex libxslt libtool_2 perl
    which yacc ] ++ optionals withDevdoc [ doxygen dblatex ];

  buildInputs = [ kerberos ncurses ];

  patches = [ ./bosserver.patch ./cross-build.patch ] ++ optional (tsmbac != null) ./tsmbac.patch;

  outputs = [ "out" "dev" "man" "doc" ] ++ optional withDevdoc "devdoc";

  enableParallelBuilding = false;

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
      "--with-docbook-stylesheets=${docbook_xsl}/share/xml/docbook-xsl"
      ${optionalString (tsmbac != null) "--enable-tivoli-tsm"}
      ${optionalString (ncurses == null) "--disable-gtx"}
      "--disable-linux-d_splice-alias-extra-iput"
    )
  '' + optionalString (tsmbac != null) ''
    export XBSA_CFLAGS="-Dxbsa -DNEW_XBSA -I${tsmbac}/lib64/sample -DXBSA_TSMLIB=\\\"${tsmbac}/lib64/libApiTSM64.so\\\""
    export XBSA_XLIBS="-ldl"
  '';

  buildFlags = [ "all_nolibafs" ];

  postBuild = ''
    for d in doc/xml/{AdminGuide,QuickStartUnix,UserGuide}; do
      make -C "''${d}" index.html
    done
  '' + optionalString withDevdoc ''
    make dox
  '';

  postInstall = ''
    mkdir -p $doc/share/doc/openafs/{AdminGuide,QuickStartUnix,UserGuide}
    cp -r doc/txt README LICENSE $doc/share/doc/openafs
    for d in AdminGuide QuickStartUnix UserGuide ; do
      cp "doc/xml/''${d}"/*.html "$doc/share/doc/openafs/''${d}"
    done

    rm -r $out/lib/openafs
  '' + optionalString withDevdoc ''
    mkdir -p $devdoc/share/devhelp/openafs/doxygen
    cp -r doc/{pdf,protocol} $devdoc/share/devhelp/openafs
    cp -r doc/doxygen/output/html $devdoc/share/devhelp/openafs/doxygen
  '';

  # Avoid references to $TMPDIR by removing it and let patchelf cleanup the
  # binaries.
  preFixup = ''
    rm -rf "$(pwd)" && mkdir "$(pwd)"
  '';

  meta = with stdenv.lib; {
    outputsToInstall = [ "out" "doc" "man" ];
    description = "Open AFS client";
    homepage = "https://www.openafs.org";
    license = licenses.ipl10;
    platforms = platforms.linux;
    maintainers = [ maintainers.maggesi maintainers.spacefrogg ];
  };
}
